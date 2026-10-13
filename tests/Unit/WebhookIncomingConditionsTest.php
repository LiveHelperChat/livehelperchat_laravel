<?php

namespace Tests\Unit;

/**
 * Incoming webhook condition tests.
 *
 * Focus areas:
 *   1. Generic condition semantics of erLhcoreClassChatWebhookIncoming::isValidCondition()
 *   2. Attribute extraction used to build chat identifiers / nick
 *      (erLhcoreClassChatWebhookIncoming::extractAttribute())
 *   3. Deep path extraction engine
 *      (erLhcoreClassGenericBotActionRestapi::extractAttribute())
 *   4. Real provider configurations vs realistic provider payloads
 *      (Messenger, Instagram, WhatsApp, Telegram, Viber, MAX)
 *
 * Migrated from the standalone lhc_web/tests suite to PHPUnit. The legacy classes
 * under test are loaded by LegacyTestCase.
 */
class WebhookIncomingConditionsTest extends LegacyTestCase
{
    /** @var array */
    protected $fixtures;

    /** @var array */
    protected $syntheticPayload;

    protected function setUp(): void
    {
        parent::setUp();

        $this->fixtures = require __DIR__ . '/fixtures/webhook_payloads.php';

        $this->syntheticPayload = [
            'object' => 'page',
            'status' => 'active',
            'count' => 0,
            'enabled' => true,
            'disabled' => false,
            'nested' => ['level1' => ['level2' => 'deepvalue']],
            'items' => [
                ['type' => 'image', 'url' => 'http://a'],
                ['type' => 'video', 'url' => 'http://b'],
            ],
            'tags' => ['a', 'b', 'c'],
            'json' => '{"foo":"bar"}',
            'meta' => ['name' => 'Alice', 'role' => 'admin'],
        ];
    }

    private function fixturePayload(array $fixture, $which)
    {
        return $which === 'full' ? $fixture['full_payload'] : $fixture['message_payload'];
    }

    private function checkCondition($field, $condition, $payload, $expected, $message)
    {
        $conditions = [$field => $condition];
        $actual = \erLhcoreClassChatWebhookIncoming::isValidCondition($field, $conditions, $payload);
        $this->assertSame($expected, $actual, $message);
    }

    /**
     * Production code walks the "|||" separated candidates and stops on the first non empty value.
     */
    private function resolveFallbackChain($conditionKey, $conditionValue, $payload)
    {
        $resolved = '';
        foreach (explode('|||', $conditionValue) as $candidate) {
            $resolved = \erLhcoreClassChatWebhookIncoming::extractAttribute($conditionKey, [$conditionKey => $candidate], $payload);
            if ($resolved != '') {
                return $resolved;
            }
        }
        return $resolved;
    }

    private function extractDeep($path, $payload = null)
    {
        return \erLhcoreClassGenericBotActionRestapi::extractAttribute(
            $payload === null ? $this->syntheticPayload : $payload,
            $path,
            '.'
        );
    }

    private function maxUpdatePayload($updateType, array $bodyOverrides = [], array $messageOverrides = [])
    {
        $body = array_merge(['mid' => 'mid.0000000000000009', 'seq' => 9, 'text' => null], $bodyOverrides);

        $message = array_merge([
            'sender' => [
                'user_id' => 123456789,
                'first_name' => 'Иван',
                'last_name' => 'Петров',
                'username' => 'ivan_p',
                'is_bot' => false,
            ],
            'recipient' => ['chat_id' => 987654321, 'chat_type' => 'dialog', 'user_id' => 123456789],
            'timestamp' => 1737500130100,
            'body' => $body,
        ], $messageOverrides);

        return ['update_type' => $updateType, 'timestamp' => 1737500130100, 'message' => $message];
    }

    private function maxCondition($conditions, $field, $payload, $expected, $message)
    {
        $this->assertSame($expected, \erLhcoreClassChatWebhookIncoming::isValidCondition($field, $conditions, $payload), $message);
    }

    // -----------------------------------------------------------------------
    // 1. Generic condition semantics
    // -----------------------------------------------------------------------
    public function test_is_valid_condition_semantics()
    {
        $p = $this->syntheticPayload;

        $this->checkCondition('main_cond', 'object=page', $p, true, 'simple equality match');
        $this->checkCondition('main_cond', 'object=instagram', $p, false, 'simple equality mismatch');
        $this->checkCondition('main_cond', 'nested.level1.level2=__exists__', $p, true, '__exists__ matches a present attribute');
        $this->checkCondition('main_cond', 'nested.level1.missing=__exists__', $p, false, '__exists__ fails on a missing attribute');
        $this->checkCondition('main_cond', 'object', $p, true, 'implicit __exists__ (no "=" sign)');
        $this->checkCondition('main_cond', 'missing', $p, false, 'implicit __exists__ fails on a missing attribute');
        $this->checkCondition('main_cond', 'enabled=true', $p, true, 'boolean literal true matches');
        $this->checkCondition('main_cond', 'enabled=false', $p, false, 'boolean literal false does not match a true value');
        $this->checkCondition('main_cond', 'disabled=false', $p, true, 'boolean literal false matches a false payload value (isset(false) is true)');
        $this->checkCondition('main_cond', 'status=active,pending', $p, true, 'comma separated values act as OR (match)');
        $this->checkCondition('main_cond', 'status=closed,pending', $p, false, 'comma separated values act as OR (no match)');
        $this->checkCondition('main_cond', 'object=page||status=active', $p, true, 'multiple conditions separated by || (all match)');
        $this->checkCondition('main_cond', 'object=page||status=closed', $p, false, 'multiple conditions separated by || (one fails => false)');
        $this->checkCondition('main_cond', 'object=instagram||status=active', $p, false, 'first || condition fails short-circuits');
        $this->checkCondition('main_cond', 'nested.level1.level2=deepvalue', $p, true, 'deep nested equality');
        $this->checkCondition('main_cond', 'items.0.type=image', $p, true, 'array index path match');
        $this->checkCondition('main_cond', 'items.1.type=image', $p, false, 'array index path mismatch');
        $this->checkCondition('main_cond', 'tags=__exists__', $p, true, '__exists__ matches an array attribute');
        $this->checkCondition('main_cond', 'count=0', $p, true, 'numeric zero compared as string');
        $this->checkCondition('main_cond', 'meta.name=Alice||meta.role=admin', $p, true, 'multiple nested conditions match');
        $this->checkCondition('main_cond', 'items.0.type=image,video', $p, true, 'comma list on a nested array element (first value matches)');
        $this->checkCondition('main_cond', 'items.1.type=image,video', $p, true, 'comma list on a nested array element (second value matches)');
        $this->checkCondition('main_cond', 'items.0.type=video,audio', $p, false, 'comma list on a nested array element (no value matches)');
        $this->checkCondition('main_cond', 'items.0.type=image,video,sticker', $p, true, 'comma list with more than two values');
        $this->checkCondition('main_cond', 'items.0.type=image, video', $p, true, 'comma list: space on a non matching value does not affect the match');
        $this->checkCondition('main_cond', 'items.0.type= image,video', $p, false, 'comma list values are not trimmed (space on the matching value breaks it)');
        $this->checkCondition('main_cond', 'items.0.type=video,image', $p, true, 'comma list order does not matter');

        // Condition field present but empty / falsy
        $this->assertFalse(
            \erLhcoreClassChatWebhookIncoming::isValidCondition('main_cond', [], $p),
            'missing condition key returns false'
        );
        $this->assertFalse(
            \erLhcoreClassChatWebhookIncoming::isValidCondition('main_cond', ['main_cond' => ''], $p),
            'empty condition value returns false'
        );
        // Documented quirk: empty() treats the string "0" as empty, so a condition of "0" is ignored.
        $this->assertFalse(
            \erLhcoreClassChatWebhookIncoming::isValidCondition('main_cond', ['main_cond' => '0'], ['0' => 'x']),
            'condition value "0" is treated as empty by PHP empty()'
        );
    }

    // -----------------------------------------------------------------------
    // 2. Incoming webhook attribute extraction
    // -----------------------------------------------------------------------
    public function test_incoming_webhook_extract_attribute()
    {
        $p = $this->syntheticPayload;

        $this->assertSame(
            'DEFAULT',
            \erLhcoreClassChatWebhookIncoming::extractAttribute('chat_id', [], $p, 'DEFAULT'),
            'missing condition key returns default'
        );
        $this->assertSame(
            'DEFAULT',
            \erLhcoreClassChatWebhookIncoming::extractAttribute('chat_id', ['chat_id' => 'missing.path'], $p, 'DEFAULT'),
            'unresolved path returns default'
        );
        $this->assertSame(
            'page',
            \erLhcoreClassChatWebhookIncoming::extractAttribute('chat_id', ['chat_id' => 'object'], $p),
            'resolves a plain attribute'
        );
        $this->assertSame(
            'deepvalue',
            \erLhcoreClassChatWebhookIncoming::extractAttribute('chat_id', ['chat_id' => 'nested.level1.level2'], $p),
            'resolves a nested attribute'
        );
        $this->assertSame(
            'http://b',
            \erLhcoreClassChatWebhookIncoming::extractAttribute('chat_id', ['chat_id' => 'items.[type=video].url'], $p),
            'resolves a value selected by [key=value] selector'
        );
        $this->assertSame(
            'b',
            \erLhcoreClassChatWebhookIncoming::extractAttribute('chat_id', ['chat_id' => 'items.[type=video].url||/||last'], $p),
            'post processing: split by / and take last part'
        );
        $this->assertSame(
            'http:',
            \erLhcoreClassChatWebhookIncoming::extractAttribute('chat_id', ['chat_id' => 'items.[type=video].url||/||0'], $p),
            'post processing: split by / and take indexed part'
        );
    }

    // -----------------------------------------------------------------------
    // 3. Deep path extraction engine
    // -----------------------------------------------------------------------
    public function test_deep_path_extraction_engine()
    {
        $result = $this->extractDeep('nested.level1.level2');
        $this->assertTrue($result['found'], 'found flag is true for existing deep path');
        $this->assertSame('deepvalue', $result['value'], 'value resolved for existing deep path');

        $result = $this->extractDeep('nested.level1.missing');
        $this->assertFalse($result['found'], 'found flag is false for missing deep path');

        $result = $this->extractDeep('items.[type=video].url');
        $this->assertSame('http://b', $result['value'], '[key=value] selector picks matching array element');

        $result = $this->extractDeep('items.[type=__EXIST__].url');
        $this->assertSame('http://b', $result['value'], '[key=__EXIST__] selector keeps the last matching element (loop uses continue, not break)');

        $result = $this->extractDeep('json___json_text.foo');
        $this->assertSame('bar', $result['value'], '___json_text decodes a JSON string attribute');

        $result = $this->extractDeep('tags^implode=={item},');
        $this->assertSame('a,b,c,', $result['value'], 'output modifiers after ^ support implode');

        // ___array_pop (Telegram photo array)
        $telegramPhotoPayload = $this->fixtures['telegram_photo']['message_payload'];
        $result = \erLhcoreClassGenericBotActionRestapi::extractAttribute($telegramPhotoPayload, 'message.photo___array_pop.file_id', '.');
        $this->assertSame('large_file_id', $result['value'], '___array_pop takes the last element of an array');
    }

    // -----------------------------------------------------------------------
    // 4. Real provider configurations against realistic payloads
    // -----------------------------------------------------------------------
    public function test_provider_payloads()
    {
        foreach ($this->fixtures as $fixtureKey => $fixture) {
            foreach ($fixture['expectations'] as $expectation) {
                $conditions = isset($expectation['conditions']) ? $expectation['conditions'] : $fixture['conditions'];
                $payload = $this->fixturePayload($fixture, $expectation['payload']);

                $actual = \erLhcoreClassChatWebhookIncoming::isValidCondition($expectation['field'], $conditions, $payload);
                $this->assertSame(
                    $expectation['expected'],
                    $actual,
                    sprintf(
                        '%s: %s (%s payload) => %s%s',
                        $fixtureKey,
                        $expectation['field'],
                        $expectation['payload'],
                        $expectation['expected'] ? 'match' : 'no match',
                        isset($expectation['note']) ? ' [' . $expectation['note'] . ']' : ''
                    )
                );
            }

            foreach (isset($fixture['attributes']) ? $fixture['attributes'] : [] as $attribute) {
                $conditions = isset($attribute['conditions']) ? $attribute['conditions'] : $fixture['conditions'];
                $payload = $this->fixturePayload($fixture, isset($attribute['payload']) ? $attribute['payload'] : 'message');
                $default = isset($attribute['default']) ? $attribute['default'] : '';

                $actual = \erLhcoreClassChatWebhookIncoming::extractAttribute($attribute['key'], $conditions, $payload, $default);
                $this->assertSame(
                    $attribute['expected'],
                    $actual,
                    sprintf('%s: extract %s', $fixtureKey, $attribute['key'])
                );
            }
        }
    }

    // -----------------------------------------------------------------------
    // 5. Cross provider isolation - one provider must not match another's payload
    // -----------------------------------------------------------------------
    public function test_cross_provider_isolation()
    {
        $messengerFull = $this->fixtures['messenger_text']['full_payload'];
        $instagramFull = $this->fixtures['instagram_text']['full_payload'];
        $whatsappFull = $this->fixtures['whatsapp_text']['full_payload'];
        $viberFull = $this->fixtures['viber_text']['full_payload'];
        $maxFull = $this->fixtures['max_message_created']['full_payload'];

        $this->assertFalse(
            \erLhcoreClassChatWebhookIncoming::isValidCondition('main_cond', ['main_cond' => 'object=page'], $instagramFull),
            'Messenger condition does not match Instagram payload'
        );
        $this->assertFalse(
            \erLhcoreClassChatWebhookIncoming::isValidCondition('main_cond', ['main_cond' => 'object=instagram'], $messengerFull),
            'Instagram condition does not match Messenger payload'
        );
        $this->assertFalse(
            \erLhcoreClassChatWebhookIncoming::isValidCondition('main_cond', ['main_cond' => 'object=whatsapp_business_account'], $messengerFull),
            'WhatsApp condition does not match Messenger payload'
        );
        $this->assertFalse(
            \erLhcoreClassChatWebhookIncoming::isValidCondition('main_cond', ['main_cond' => 'object=page'], $whatsappFull),
            'Messenger condition does not match WhatsApp payload'
        );
        $this->assertFalse(
            \erLhcoreClassChatWebhookIncoming::isValidCondition('main_cond', ['main_cond' => 'event=message'], $messengerFull),
            'Viber condition does not match Messenger payload'
        );
        $this->assertTrue(
            \erLhcoreClassChatWebhookIncoming::isValidCondition('main_cond', ['main_cond' => 'event=message'], $viberFull),
            'Viber condition matches its own payload'
        );
        $this->assertFalse(
            \erLhcoreClassChatWebhookIncoming::isValidCondition('main_cond', ['main_cond' => 'update_type=message_created,message_callback,bot_started'], $messengerFull),
            'MAX condition does not match Messenger payload'
        );
        $this->assertFalse(
            \erLhcoreClassChatWebhookIncoming::isValidCondition('main_cond', ['main_cond' => 'object=page'], $maxFull),
            'Messenger condition does not match MAX payload'
        );
        $this->assertTrue(
            \erLhcoreClassChatWebhookIncoming::isValidCondition('main_cond', ['main_cond' => 'update_type=message_created,message_callback,bot_started'], $maxFull),
            'MAX condition matches its own payload'
        );
    }

    // -----------------------------------------------------------------------
    // 6. Telegram chat_id fallback chain (message -> callback_query -> edited_message)
    // -----------------------------------------------------------------------
    public function test_telegram_chat_id_fallback_chain()
    {
        $telegramChatIdCondition = 'message.chat.id|||callback_query.message.chat.id|||edited_message.chat.id';

        $this->assertSame(
            777000,
            $this->resolveFallbackChain('chat_id', $telegramChatIdCondition, $this->fixtures['telegram_text']['message_payload']),
            'text message resolves chat id from message.chat.id'
        );
        $this->assertSame(
            777000,
            $this->resolveFallbackChain('chat_id', $telegramChatIdCondition, $this->fixtures['telegram_callback']['message_payload']),
            'callback query falls back to callback_query.message.chat.id'
        );
        $this->assertSame(
            '',
            $this->resolveFallbackChain('chat_id', $telegramChatIdCondition, ['update_id' => 1]),
            'no candidate resolves for an unrelated payload'
        );
        $this->assertSame(
            777000,
            \erLhcoreClassChatWebhookIncoming::extractAttribute('chat_id', ['chat_id' => 'message.chat.id'], $this->fixtures['telegram_text']['message_payload']),
            'direct message.chat.id extraction works'
        );

        // extractAttribute() only understands a single "path||delimiter||index" suffix. Passing the raw
        // "|||" fallback chain with 3+ candidates makes PHP split it into extra params, so callers must
        // walk the candidates themselves (as done by resolveFallbackChain() above).
        $conditions = ['chat_id' => $telegramChatIdCondition];
        $this->assertSame(
            '777000',
            \erLhcoreClassChatWebhookIncoming::extractAttribute('chat_id', $conditions, $this->fixtures['telegram_text']['message_payload']),
            'raw 3-candidate ||| value must be pre-split by callers (returns a string otherwise)'
        );
    }

    // -----------------------------------------------------------------------
    // 7. MAX (Max Messenger) attachment types
    // Payload shapes from https://github.com/max-messenger/api-schema
    // -----------------------------------------------------------------------
    public function test_max_attachment_types()
    {
        $maxConditions = $this->fixtures['max_message_created']['conditions'];

        $maxImage = ['type' => 'image', 'payload' => ['photo_id' => 123, 'token' => 'photo-token', 'url' => 'https://cdn.max.ru/photo.jpg'], 'width' => 800, 'height' => 600];
        $maxSticker = ['type' => 'sticker', 'payload' => ['code' => 'sticker-code', 'url' => 'https://cdn.max.ru/sticker.png'], 'width' => 512, 'height' => 512];
        $maxVideo = ['type' => 'video', 'payload' => ['url' => 'https://cdn.max.ru/video.mp4', 'token' => 'video-token'], 'width' => 1280, 'height' => 720, 'duration' => 12];
        $maxAudio = ['type' => 'audio', 'payload' => ['url' => 'https://cdn.max.ru/audio.mp3', 'token' => 'audio-token']];
        $maxFile = ['type' => 'file', 'payload' => ['url' => 'https://cdn.max.ru/report.pdf', 'token' => 'file-token'], 'filename' => 'report.pdf', 'size' => 12345];

        $maxImagePayload = $this->maxUpdatePayload('message_created', ['attachments' => [$maxImage]]);
        $maxStickerPayload = $this->maxUpdatePayload('message_created', ['attachments' => [$maxSticker]]);
        $maxVideoPayload = $this->maxUpdatePayload('message_created', ['attachments' => [$maxVideo]]);
        $maxAudioPayload = $this->maxUpdatePayload('message_created', ['attachments' => [$maxAudio]]);
        $maxFilePayload = $this->maxUpdatePayload('message_created', ['attachments' => [$maxFile]]);

        // image
        $this->maxCondition($maxConditions, 'msg_cond_img', $maxImagePayload, true, 'image matches image,sticker');
        $this->maxCondition($maxConditions, 'msg_cond_img_2', $maxImagePayload, false, 'image does not match video');
        $this->maxCondition($maxConditions, 'msg_cond_img_3', $maxImagePayload, false, 'image does not match audio');
        $this->maxCondition($maxConditions, 'msg_cond_attachments', $maxImagePayload, false, 'image does not match file');

        // sticker - the second value of the comma separated list
        $this->maxCondition($maxConditions, 'msg_cond_img', $maxStickerPayload, true, 'sticker matches image,sticker');
        $this->maxCondition($maxConditions, 'msg_cond_img_2', $maxStickerPayload, false, 'sticker does not match video');
        $this->maxCondition(
            ['msg_cond_img' => 'message.body.attachments.0.type=sticker,image'],
            'msg_cond_img',
            $maxStickerPayload,
            true,
            'sticker matches when the comma list order is reversed'
        );
        $this->maxCondition(
            ['msg_cond_img' => 'message.body.attachments.0.type=image'],
            'msg_cond_img',
            $maxStickerPayload,
            false,
            'sticker does not match a plain image condition'
        );

        // video
        $this->maxCondition($maxConditions, 'msg_cond_img', $maxVideoPayload, false, 'video is not image,sticker');
        $this->maxCondition($maxConditions, 'msg_cond_img_2', $maxVideoPayload, true, 'video matches video');
        $this->maxCondition($maxConditions, 'msg_cond_img_3', $maxVideoPayload, false, 'video does not match audio');

        // audio
        $this->maxCondition($maxConditions, 'msg_cond_img', $maxAudioPayload, false, 'audio is not image,sticker');
        $this->maxCondition($maxConditions, 'msg_cond_img_2', $maxAudioPayload, false, 'audio does not match video');
        $this->maxCondition($maxConditions, 'msg_cond_img_3', $maxAudioPayload, true, 'audio matches audio');

        // file
        $this->maxCondition($maxConditions, 'msg_cond_attachments', $maxFilePayload, true, 'file matches file');
        $this->maxCondition($maxConditions, 'msg_cond_img', $maxFilePayload, false, 'file is not image,sticker');
        $this->maxCondition($maxConditions, 'msg_cond_img_2', $maxFilePayload, false, 'file does not match video');

        // attachment metadata extraction
        $this->assertSame(
            'https://cdn.max.ru/photo.jpg',
            \erLhcoreClassChatWebhookIncoming::extractAttribute('msg_cond_img_body', $maxConditions, $maxImagePayload),
            'image attachment url extracted'
        );
        $this->assertSame(
            'report.pdf',
            \erLhcoreClassChatWebhookIncoming::extractAttribute('msg_cond_img_file_name', $maxConditions, $maxFilePayload),
            'file attachment name extracted'
        );
        $this->assertSame(
            12345,
            \erLhcoreClassChatWebhookIncoming::extractAttribute('msg_cond_img_file_size', $maxConditions, $maxFilePayload),
            'file attachment size extracted'
        );
        $this->assertSame(
            [$maxFile],
            \erLhcoreClassChatWebhookIncoming::extractAttribute('msg_cond_img_array', $maxConditions, $maxFilePayload),
            'attachments array extracted'
        );
    }

    // -----------------------------------------------------------------------
    // 8. MAX nick / chat_id fallback chains
    // -----------------------------------------------------------------------
    public function test_max_nick_chat_id_fallback_chains()
    {
        $maxConditions = $this->fixtures['max_message_created']['conditions'];
        $maxMessageCreatedPayload = $this->fixtures['max_message_created']['full_payload'];
        $maxBotStartedPayload = $this->fixtures['max_bot_started']['full_payload'];
        $maxCallbackPayload = $this->fixtures['max_message_callback']['full_payload'];

        $this->assertSame(
            'Иван',
            $this->resolveFallbackChain('nick', $maxConditions['nick'], $maxMessageCreatedPayload),
            'message_created nick from message.sender.first_name'
        );
        $this->assertSame(
            'MyBot',
            $this->resolveFallbackChain('nick', $maxConditions['nick'], $maxCallbackPayload),
            'message_callback nick from the original message sender'
        );
        $this->assertSame(
            'Иван',
            $this->resolveFallbackChain('nick', $maxConditions['nick'], $maxBotStartedPayload),
            'bot_started nick falls back to user.first_name'
        );
        $this->assertSame(
            987654321,
            $this->resolveFallbackChain('chat_id', $maxConditions['chat_id'], $maxMessageCreatedPayload),
            'message_created chat_id from message.recipient.chat_id'
        );
        $this->assertSame(
            987654321,
            $this->resolveFallbackChain('chat_id', $maxConditions['chat_id'], $maxBotStartedPayload),
            'bot_started chat_id falls back to the root chat_id'
        );
        $this->assertSame(
            '',
            $this->resolveFallbackChain('nick', $maxConditions['nick'], ['update_type' => 'bot_stopped']),
            'no nick candidate resolves for an unrelated update'
        );
    }

    // -----------------------------------------------------------------------
    // 9. MAX reply chain (message.link -> attachment reply_to)
    // -----------------------------------------------------------------------
    public function test_max_reply_chain()
    {
        $maxReplyCondition = 'message.link.message.mid|||message.body.link.message.mid|||message.link.mid|||message.body.link.mid|||message.body.attachments.0.reply_to.mid|||message.body.attachments.0.reply_to.message_id|||message.body.reply_to.mid|||message.reply_to.mid';

        $maxFile = ['type' => 'file', 'payload' => ['url' => 'https://cdn.max.ru/report.pdf', 'token' => 'file-token'], 'filename' => 'report.pdf', 'size' => 12345];

        // message.link.message.mid (primary shape from the MAX schema)
        $replyViaLink = $this->maxUpdatePayload('message_created', ['text' => 'This is a reply'], [
            'link' => ['type' => 'reply', 'message' => ['mid' => 'mid.original001', 'seq' => 1]],
        ]);
        $this->assertSame(
            'mid.original001',
            $this->resolveFallbackChain('message_id_reply', $maxReplyCondition, $replyViaLink),
            'reply id resolved from message.link.message.mid'
        );

        // message.body.attachments.0.reply_to.message_id (fallback shape)
        $replyViaAttachment = $this->maxUpdatePayload('message_created', [
            'attachments' => [array_merge($maxFile, ['reply_to' => ['message_id' => 'mid.original002']])],
        ]);
        $this->assertSame(
            'mid.original002',
            $this->resolveFallbackChain('message_id_reply', $maxReplyCondition, $replyViaAttachment),
            'reply id resolved from attachments.0.reply_to.message_id'
        );

        // message.reply_to.mid (last fallback shape)
        $replyViaBody = $this->maxUpdatePayload('message_created', ['text' => 'reply', 'reply_to' => ['mid' => 'mid.original003']]);
        $this->assertSame(
            'mid.original003',
            $this->resolveFallbackChain('message_id_reply', $maxReplyCondition, $replyViaBody),
            'reply id resolved from message.body.reply_to.mid'
        );

        $this->assertSame(
            '',
            $this->resolveFallbackChain('message_id_reply', $maxReplyCondition, $this->maxUpdatePayload('message_created', ['text' => 'no reply'])),
            'no reply candidate resolves for a plain message'
        );
    }
}
