<?php

namespace Tests\Unit;

/**
 * Tests for erLhcoreClassChatWebhookIncoming::processMessage() message type / sender
 * determination.
 *
 * processMessage() is called with the 4th argument $returnDeterminedData = true, which makes it
 * return what it determined (message type, body template, sender, operator condition) right after
 * the pure condition matching and before any database access. This keeps the tests dependency free.
 *
 * Migrated from the standalone lhc_web/tests suite to PHPUnit. The legacy classes under test are
 * loaded by LegacyTestCase.
 */
class WebhookIncomingProcessMessageTest extends LegacyTestCase
{
    /** @var array */
    protected $fixtures;

    protected function setUp(): void
    {
        parent::setUp();

        $this->fixtures = require __DIR__ . '/fixtures/webhook_payloads.php';
    }

    /**
     * Whatever body templates a branch reads must exist, otherwise processMessage() would raise an
     * undefined array key warning. Only templates read unconditionally or guarded by their own
     * condition key are defaulted; msg_body_2/3/4 are deliberately NOT defaulted because their
     * presence alone activates a branch.
     */
    private function pmConditions(array $conditions)
    {
        return array_merge([
            'msg_body' => '{{msg.body}}',
            'msg_img' => '{{msg.img}}',
            'msg_img_2' => '{{msg.img_2}}',
            'msg_img_3' => '{{msg.img_3}}',
            'msg_attachments' => '{{msg.attachments}}',
        ], $conditions);
    }

    /**
     * Runs processMessage() in dry-run mode and returns the determined data.
     */
    private function processMessageDetermine(array $conditions, $payloadMessage, $payloadAll = null)
    {
        $incomingWebhook = new \stdClass();
        $incomingWebhook->conditions_array = $this->pmConditions($conditions);

        return \erLhcoreClassChatWebhookIncoming::processMessage(
            $incomingWebhook,
            $payloadMessage,
            $payloadAll === null ? $payloadMessage : $payloadAll,
            true
        );
    }

    private function pmMaxMessage($updateType, array $bodyOverrides = [])
    {
        return [
            'update_type' => $updateType,
            'timestamp' => 1737500130100,
            'message' => [
                'sender' => [
                    'user_id' => 123456789,
                    'first_name' => 'Иван',
                    'last_name' => 'Петров',
                    'username' => 'ivan_p',
                    'is_bot' => false,
                ],
                'recipient' => ['chat_id' => 987654321, 'chat_type' => 'dialog', 'user_id' => 123456789],
                'timestamp' => 1737500130100,
                'body' => array_merge(['mid' => 'mid.0000000000000009', 'seq' => 9, 'text' => null], $bodyOverrides),
            ],
        ];
    }

    private function pmThrows($conditions, $payloadMessage, $payloadAll = null)
    {
        try {
            $this->processMessageDetermine($conditions, $payloadMessage, $payloadAll);
        } catch (\Exception $e) {
            return true;
        }
        return false;
    }

    private function maxConditions()
    {
        return $this->fixtures['max_message_created']['conditions'];
    }

    // -----------------------------------------------------------------------
    // 1. Message type / sender determination for every provider fixture
    // -----------------------------------------------------------------------
    public function test_process_message_determination_for_all_provider_fixtures()
    {
        foreach ($this->fixtures as $fixtureKey => $fixture) {
            if (!isset($fixture['process_message'])) {
                continue;
            }

            $expected = $fixture['process_message'];
            $label = $fixtureKey . ': ' . $fixture['provider'] . ' - ' . $fixture['description'];
            $note = isset($expected['note']) ? ' [' . $expected['note'] . ']' : '';

            if ($expected['type'] === null) {
                $this->assertTrue(
                    $this->pmThrows($fixture['conditions'], $fixture['message_payload'], $fixture['full_payload']),
                    $label . ' => no branch matches, processMessage throws' . $note
                );
                continue;
            }

            $result = $this->processMessageDetermine($fixture['conditions'], $fixture['message_payload'], $fixture['full_payload']);
            $this->assertSame($expected['type'], $result['type'], $label . ' => type ' . $expected['type'] . $note);

            if (isset($expected['sender'])) {
                $this->assertSame($expected['sender'], $result['sender'], $label . ' => sender ' . $expected['sender']);
            }
        }
    }

    // -----------------------------------------------------------------------
    // 2. MAX attachment type variants
    // Payload variants that are not separate fixtures (MAX attachment types other than the
    // documented text/callback/bot_started ones), driven through the same MAX conditions.
    // -----------------------------------------------------------------------
    public function test_max_attachment_type_variants()
    {
        $maxImage = ['type' => 'image', 'payload' => ['photo_id' => 123, 'token' => 'photo-token', 'url' => 'https://cdn.max.ru/photo.jpg'], 'width' => 800, 'height' => 600];
        $maxSticker = ['type' => 'sticker', 'payload' => ['code' => 'sticker-code', 'url' => 'https://cdn.max.ru/sticker.png'], 'width' => 512, 'height' => 512];
        $maxVideo = ['type' => 'video', 'payload' => ['url' => 'https://cdn.max.ru/video.mp4', 'token' => 'video-token'], 'width' => 1280, 'height' => 720];
        $maxAudio = ['type' => 'audio', 'payload' => ['url' => 'https://cdn.max.ru/audio.mp3', 'token' => 'audio-token']];
        $maxFile = ['type' => 'file', 'payload' => ['url' => 'https://cdn.max.ru/report.pdf', 'token' => 'file-token'], 'filename' => 'report.pdf', 'size' => 12345];

        $maxAttachmentCases = [
            ['image', $maxImage, 'img'],
            ['sticker', $maxSticker, 'img'],
            ['video', $maxVideo, 'img_2'],
            ['audio', $maxAudio, 'img_3'],
            ['file', $maxFile, 'attachments'],
        ];

        foreach ($maxAttachmentCases as $maxAttachmentCase) {
            list($attachmentName, $attachment, $expectedType) = $maxAttachmentCase;
            $result = $this->processMessageDetermine($this->maxConditions(), $this->pmMaxMessage('message_created', ['attachments' => [$attachment]]));
            $this->assertSame($expectedType, $result['type'], 'MAX ' . $attachmentName . ' attachment => type ' . $expectedType);
        }
    }

    // -----------------------------------------------------------------------
    // 3. Sender (visitor vs operator) detection
    // -----------------------------------------------------------------------
    public function test_sender_detection()
    {
        $result = $this->processMessageDetermine($this->fixtures['messenger_text']['conditions'], $this->fixtures['messenger_text']['message_payload']);
        $this->assertSame(0, $result['sender'], 'Messenger visitor message => sender 0');
        $this->assertSame('msg_cond_op', $result['operator_condition_key'], 'Messenger visitor message => operator condition key msg_cond_op');
        $this->assertSame('messaging.0.message.is_echo=true', $result['operator_condition'], 'Messenger visitor message => operator condition is msg_cond_op');

        $result = $this->processMessageDetermine($this->fixtures['messenger_echo']['conditions'], $this->fixtures['messenger_echo']['message_payload']);
        $this->assertSame(-2, $result['sender'], 'Messenger echo message => sender -2 (operator)');
        $this->assertSame('msg_cond_op', $result['operator_condition_key'], 'Messenger echo message => operator condition key msg_cond_op');

        $result = $this->processMessageDetermine($this->maxConditions(), $this->fixtures['max_message_created']['message_payload']);
        $this->assertSame(0, $result['sender'], 'MAX visitor message => sender 0');
        $this->assertSame('', $result['operator_condition'], 'MAX has no msg_cond_op configured => empty operator condition');
        $this->assertSame('msg_cond_op', $result['operator_condition_key'], 'text branch always reports msg_cond_op as the operator condition key');

        $result = $this->processMessageDetermine($this->fixtures['telegram_text']['conditions'], $this->fixtures['telegram_text']['message_payload']);
        $this->assertSame(0, $result['sender'], 'Telegram text => sender 0');
    }

    // -----------------------------------------------------------------------
    // 4. Unread operator flow flag
    // -----------------------------------------------------------------------
    public function test_unread_operator_flow()
    {
        $result = $this->processMessageDetermine($this->fixtures['messenger_echo']['conditions'], $this->fixtures['messenger_echo']['message_payload']);
        $this->assertFalse($result['enable_unread_op_flow'], 'echo without msg_cond_op_unread => unread flow disabled');

        $echoUnreadConditions = array_merge($this->fixtures['messenger_echo']['conditions'], ['msg_cond_op_unread' => true]);
        $result = $this->processMessageDetermine($echoUnreadConditions, $this->fixtures['messenger_echo']['message_payload']);
        $this->assertTrue($result['enable_unread_op_flow'], 'echo with msg_cond_op_unread => unread flow enabled');

        $result = $this->processMessageDetermine($this->fixtures['messenger_text']['conditions'], $this->fixtures['messenger_text']['message_payload']);
        $this->assertFalse($result['enable_unread_op_flow'], 'visitor message => unread flow disabled even with the flag set');

        $visitorUnreadConditions = array_merge($this->fixtures['messenger_text']['conditions'], ['msg_cond_op_unread' => true]);
        $result = $this->processMessageDetermine($visitorUnreadConditions, $this->fixtures['messenger_text']['message_payload']);
        $this->assertFalse($result['enable_unread_op_flow'], 'visitor message with msg_cond_op_unread => still disabled (sender is 0)');
    }

    // -----------------------------------------------------------------------
    // 5. Unmatched conditions throw
    // -----------------------------------------------------------------------
    public function test_unmatched_conditions_throw()
    {
        $this->assertTrue(
            $this->pmThrows($this->maxConditions(), $this->fixtures['messenger_text']['message_payload']),
            'MAX conditions with a Messenger payload => exception'
        );
        $this->assertTrue(
            $this->pmThrows($this->maxConditions(), $this->fixtures['messenger_delivery']['message_payload']),
            'MAX conditions with a Messenger delivery receipt => exception'
        );
        $this->assertTrue(
            $this->pmThrows($this->fixtures['messenger_text']['conditions'], $this->fixtures['messenger_delivery']['message_payload']),
            'Messenger text conditions with a delivery receipt => exception (no message body)'
        );
        $this->assertTrue(
            $this->pmThrows($this->fixtures['viber_text']['conditions'], $this->fixtures['messenger_text']['message_payload']),
            'Viber conditions with a Messenger payload => exception'
        );
    }

    // -----------------------------------------------------------------------
    // 6. Branch precedence
    // -----------------------------------------------------------------------
    public function test_branch_precedence()
    {
        $maxImage = ['type' => 'image', 'payload' => ['photo_id' => 123, 'token' => 'photo-token', 'url' => 'https://cdn.max.ru/photo.jpg'], 'width' => 800, 'height' => 600];
        $maxFile = ['type' => 'file', 'payload' => ['url' => 'https://cdn.max.ru/report.pdf', 'token' => 'file-token'], 'filename' => 'report.pdf', 'size' => 12345];

        // attachments are checked before img
        $bothMatch = array_merge($this->maxConditions(), ['msg_cond_img' => 'message.body.attachments.0.type=file,image,sticker']);
        $result = $this->processMessageDetermine($bothMatch, $this->pmMaxMessage('message_created', ['attachments' => [$maxFile]]));
        $this->assertSame('attachments', $result['type'], 'attachments branch wins over img when both conditions match');

        // img is checked before img_2
        $bothImages = array_merge($this->maxConditions(), ['msg_cond_img_2' => 'message.body.attachments.0.type=image']);
        $result = $this->processMessageDetermine($bothImages, $this->pmMaxMessage('message_created', ['attachments' => [$maxImage]]));
        $this->assertSame('img', $result['type'], 'img branch wins over img_2 when both conditions match');

        // msg_body_2 branch is evaluated before the generic msg_cond branch
        $result = $this->processMessageDetermine($this->maxConditions(), $this->fixtures['max_bot_started']['message_payload']);
        $this->assertSame('text', $result['type'], 'bot_started is handled by the msg_body_2/msg_cond_2 branch');
    }

    // -----------------------------------------------------------------------
    // 7. Determined body template can be rendered against the payload
    // -----------------------------------------------------------------------
    public function test_body_template()
    {
        $maxFile = ['type' => 'file', 'payload' => ['url' => 'https://cdn.max.ru/report.pdf', 'token' => 'file-token'], 'filename' => 'report.pdf', 'size' => 12345];

        $result = $this->processMessageDetermine($this->maxConditions(), $this->fixtures['max_message_created']['message_payload']);
        $this->assertSame('{{msg.message.body.text}}', $result['body'], 'MAX text message => configured msg_body template returned');
        $this->assertSame(
            'Здравствуйте!',
            \erLhcoreClassChatWebhookIncoming::extractMessageBody($result['body'], $this->fixtures['max_message_created']['message_payload']),
            'MAX text message => body template renders the text'
        );

        $result = $this->processMessageDetermine($this->maxConditions(), $this->fixtures['max_bot_started']['message_payload']);
        $this->assertSame('/start', $result['body'], 'MAX bot_started => configured msg_body_2 template returned');

        $result = $this->processMessageDetermine($this->maxConditions(), $this->pmMaxMessage('message_created', ['attachments' => [$maxFile]]));
        $this->assertSame(
            '{{msg.message.body.text}} {{msg.message.body.attachments.0.payload.url}}',
            $result['body'],
            'MAX file attachment => configured msg_attachments template returned'
        );

        $telegramText = $this->fixtures['telegram_text']['message_payload'];
        $result = $this->processMessageDetermine(
            array_merge($this->fixtures['telegram_text']['conditions'], ['msg_body' => '{{msg.message.text}}']),
            $telegramText
        );
        $this->assertSame('{{msg.message.text}}', $result['body'], 'Telegram text => configured msg_body template returned');
        $this->assertSame(
            'Hello, bot!',
            \erLhcoreClassChatWebhookIncoming::extractMessageBody($result['body'], $telegramText),
            'Telegram text => body template renders the text'
        );
    }
}
