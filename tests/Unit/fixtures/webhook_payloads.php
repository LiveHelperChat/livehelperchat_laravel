<?php

/**
 * Realistic incoming webhook payloads and the condition configurations shipped
 * by Live Helper Chat for the supported providers.
 *
 * The condition arrays are taken from the provider documentation:
 *   - Facebook Messenger: https://github.com/LiveHelperChat/fbmessenger/tree/master/doc/messenger
 *   - Instagram:          https://github.com/LiveHelperChat/fbmessenger/tree/master/doc/instagram
 *   - WhatsApp:           https://github.com/LiveHelperChat/fbmessenger/tree/master/doc/whatsapp
 *   - Telegram:           extension/lhctelegram/doc/telegram/incoming-webhook.json
 *
 * Payloads follow the official provider formats:
 *   - https://developers.facebook.com/docs/messenger-platform/webhooks
 *   - https://developers.facebook.com/docs/instagram-platform/webhooks
 *   - https://developers.facebook.com/docs/whatsapp/cloud-api/webhooks/payload-examples
 *   - https://core.telegram.org/bots/api#update
 *   - https://developers.viber.com/docs/api/rest-bot-api/#callbacks
 *
 * Each fixture contains:
 *   - conditions      : webhook conditions array (the same shape stored by the admin UI)
 *   - full_payload    : the whole webhook body ($payload passed to processEvent)
 *   - message_payload : the item iterated over ($payloadMessage) - for providers where
 *                       conditions['messages'] points to a sub-array, this is that element
 *   - expectations    : [field, payload (full|message), expected, conditions?]
 *   - attributes      : [key, payload (full|message), expected, default?, conditions?]
 */

// MAX (Max Messenger) conditions as shipped by the lhcmax extension:
// https://github.com/LiveHelperChat/lhcmax/blob/master/doc/max/incoming-webhook.json
$maxConditions = [
    'messages' => '',
    'message_direct' => true,
    'message_id' => 'message.body.mid',
    'nick' => 'message.sender.first_name|||message.sender.last_name|||message.sender.username|||callback.user.first_name|||user.first_name',
    'chat_id' => 'message.recipient.chat_id|||chat_id',
    'main_cond' => 'update_type=message_created,message_callback,bot_started',
    'msg_body' => '{{msg.message.body.text}}',
    'msg_cond' => 'update_type=message_created',
    'msg_body_2' => '/start',
    'msg_cond_2' => 'update_type=bot_started',
    'msg_cond_img' => 'message.body.attachments.0.type=image,sticker',
    'msg_img' => '{{msg.message.body.text}} {{msg.message.body.attachments.0.payload.url}}',
    'msg_cond_img_2' => 'message.body.attachments.0.type=video',
    'msg_img_2' => '{{msg.message.body.text}} {{msg.message.body.attachments.0.payload.url}}',
    'msg_cond_img_3' => 'message.body.attachments.0.type=audio',
    'msg_img_3' => '{{msg.message.body.text}} {{msg.message.body.attachments.0.payload.url}}',
    'msg_cond_attachments' => 'message.body.attachments.0.type=file',
    'msg_attachments' => '{{msg.message.body.text}} {{msg.message.body.attachments.0.payload.url}}',
    'msg_cond_img_body' => 'message.body.attachments.0.payload.url',
    'msg_cond_img_file_name' => 'message.body.attachments.0.filename',
    'msg_cond_img_file_size' => 'message.body.attachments.0.size',
    'msg_cond_img_array' => 'message.body.attachments',
    'msg_btn_cond_1' => 'update_type=message_callback||callback.payload=__exists__',
    'msg_btn_payload_1' => 'callback.payload',
    'msg_btn_message_id' => 'callback.callback_id',
];

$maxMessageCreatedPayload = [
    'update_type' => 'message_created',
    'timestamp' => 1737500130100,
    'message' => [
        'sender' => [
            'user_id' => 123456789,
            'first_name' => 'Иван',
            'last_name' => 'Петров',
            'username' => 'ivan_p',
            'is_bot' => false,
        ],
        'recipient' => [
            'chat_id' => 987654321,
            'chat_type' => 'dialog',
            'user_id' => 123456789,
        ],
        'timestamp' => 1737500130100,
        'body' => [
            'mid' => 'mid.0000000000000001',
            'seq' => 1,
            'text' => 'Здравствуйте!',
        ],
    ],
];

// Telegram conditions as shipped by the lhctelegram extension, including the negated
// main_cond: supergroup chats are ignored while private chats and callback queries are
// accepted (a callback query has no root message.chat.type, so the negated condition is
// met because the attribute is missing).
// extension/lhctelegram/doc/telegram/incoming-webhook.json
$telegramMainCondConditions = [
    'messages' => '',
    'message_direct' => true,
    'main_cond' => 'message.chat.type!=supergroup',
    'nick' => 'message.from.first_name|||message.from.last_name|||callback_query.from.first_name|||callback_query.from.last_name',
    'chat_id' => 'message.chat.id|||callback_query.message.chat.id|||edited_message.chat.id',
    'msg_cond' => 'message.text=__exists__',
    'msg_cond_img' => 'message.photo=__exists__',
    'msg_cond_attachments' => 'message.document=__exists__',
    'msg_btn_cond_1' => 'callback_query.data=__exists__',
];

return [

    // ---------------------------------------------------------------------
    // Facebook Messenger
    // https://github.com/LiveHelperChat/fbmessenger/tree/master/doc/messenger
    // ---------------------------------------------------------------------
    'messenger_text' => [
        'process_message' => ['type' => 'text', 'sender' => 0],
        'provider' => 'Facebook Messenger',
        'description' => 'Incoming visitor text message',
        'conditions' => [
            'messages' => 'entry',
            'main_cond' => 'object=page',
            'nick' => 'messaging.0.sender.id',
            'chat_id' => 'messaging.0.sender.id',
            'chat_id_2' => 'messaging.0.recipient.id',
            'chat_id_switch' => 'messaging.0.message.is_echo=true',
            'msg_cond' => 'messaging.0.message.text=__exists__',
            'msg_cond_op' => 'messaging.0.message.is_echo=true',
            'msg_delivery_delivered_condition' => 'messaging.0.delivery.mids=__exists__',
        ],
        'full_payload' => [
            'object' => 'page',
            'entry' => [
                [
                    'id' => '102261416447152',
                    'time' => 1458692752478,
                    'messaging' => [
                        [
                            'sender' => ['id' => '1234567890'],
                            'recipient' => ['id' => '102261416447152'],
                            'timestamp' => 1458692752478,
                            'message' => [
                                'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
                                'text' => 'Hello, world!',
                            ],
                        ],
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'id' => '102261416447152',
            'time' => 1458692752478,
            'messaging' => [
                [
                    'sender' => ['id' => '1234567890'],
                    'recipient' => ['id' => '102261416447152'],
                    'timestamp' => 1458692752478,
                    'message' => [
                        'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
                        'text' => 'Hello, world!',
                    ],
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'main_cond', 'payload' => 'full', 'expected' => true],
            ['field' => 'main_cond', 'payload' => 'message', 'expected' => false, 'note' => 'object lives on the root payload only'],
            ['field' => 'msg_cond', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_cond_op', 'payload' => 'message', 'expected' => false],
            ['field' => 'chat_id_switch', 'payload' => 'message', 'expected' => false],
            ['field' => 'msg_delivery_delivered_condition', 'payload' => 'message', 'expected' => false],
        ],
        'attributes' => [
            ['key' => 'chat_id', 'expected' => '1234567890'],
            ['key' => 'chat_id_2', 'expected' => '102261416447152'],
            ['key' => 'nick', 'expected' => '1234567890'],
        ],
    ],

    'messenger_echo' => [
        'process_message' => ['type' => 'text', 'sender' => -2],
        'provider' => 'Facebook Messenger',
        'description' => 'Page echo message (message sent by the page itself)',
        'conditions' => [
            'messages' => 'entry',
            'main_cond' => 'object=page',
            'chat_id' => 'messaging.0.sender.id',
            'chat_id_2' => 'messaging.0.recipient.id',
            'chat_id_switch' => 'messaging.0.message.is_echo=true',
            'msg_cond' => 'messaging.0.message.text=__exists__',
            'msg_cond_op' => 'messaging.0.message.is_echo=true',
        ],
        'full_payload' => [
            'object' => 'page',
            'entry' => [
                [
                    'id' => '102261416447152',
                    'time' => 1458692752478,
                    'messaging' => [
                        [
                            'sender' => ['id' => '102261416447152'],
                            'recipient' => ['id' => '1234567890'],
                            'timestamp' => 1458692752478,
                            'message' => [
                                'is_echo' => true,
                                'app_id' => 123456789,
                                'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
                                'text' => 'Echoed text',
                            ],
                        ],
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'id' => '102261416447152',
            'time' => 1458692752478,
            'messaging' => [
                [
                    'sender' => ['id' => '102261416447152'],
                    'recipient' => ['id' => '1234567890'],
                    'timestamp' => 1458692752478,
                    'message' => [
                        'is_echo' => true,
                        'app_id' => 123456789,
                        'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
                        'text' => 'Echoed text',
                    ],
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'main_cond', 'payload' => 'full', 'expected' => true],
            ['field' => 'msg_cond', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_cond_op', 'payload' => 'message', 'expected' => true],
            ['field' => 'chat_id_switch', 'payload' => 'message', 'expected' => true],
        ],
    ],

    'messenger_delivery' => [
        'process_message' => ['type' => null, 'note' => 'delivery receipt, no message branch matches'],
        'provider' => 'Facebook Messenger',
        'description' => 'Delivery receipt callback',
        'conditions' => [
            'messages' => 'entry',
            'main_cond' => 'object=page',
            'msg_delivery_delivered_id' => 'messaging.0.delivery.mids.0',
            'msg_delivery_delivered_condition' => 'messaging.0.delivery.mids=__exists__',
            'msg_delivery_read_condition' => 'messaging.0.read.watermark=__exists__',
            'msg_cond' => 'messaging.0.message.text=__exists__',
        ],
        'full_payload' => [
            'object' => 'page',
            'entry' => [
                [
                    'id' => '102261416447152',
                    'time' => 1458668856253,
                    'messaging' => [
                        [
                            'sender' => ['id' => '1234567890'],
                            'recipient' => ['id' => '102261416447152'],
                            'timestamp' => 1458668856253,
                            'delivery' => [
                                'mids' => ['mid.1458668856218:ed81099e15d3f4f233'],
                                'watermark' => 1458668856253,
                                'seq' => 37,
                            ],
                        ],
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'id' => '102261416447152',
            'time' => 1458668856253,
            'messaging' => [
                [
                    'sender' => ['id' => '1234567890'],
                    'recipient' => ['id' => '102261416447152'],
                    'timestamp' => 1458668856253,
                    'delivery' => [
                        'mids' => ['mid.1458668856218:ed81099e15d3f4f233'],
                        'watermark' => 1458668856253,
                        'seq' => 37,
                    ],
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'msg_delivery_delivered_condition', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_delivery_read_condition', 'payload' => 'message', 'expected' => false],
            ['field' => 'msg_cond', 'payload' => 'message', 'expected' => false, 'note' => 'delivery receipt has no message body'],
        ],
        'attributes' => [
            ['key' => 'msg_delivery_delivered_id', 'expected' => 'mid.1458668856218:ed81099e15d3f4f233'],
        ],
    ],

    'messenger_read' => [
        'process_message' => ['type' => 'text', 'sender' => 0, 'note' => 'no msg_cond configured, defaults to text'],
        'provider' => 'Facebook Messenger',
        'description' => 'Read receipt callback',
        'conditions' => [
            'messages' => 'entry',
            'main_cond' => 'object=page',
            'msg_delivery_read_id' => 'messaging.0.read.watermark',
            'msg_delivery_read_condition' => 'messaging.0.read.watermark=__exists__',
            'msg_delivery_delivered_condition' => 'messaging.0.delivery.mids=__exists__',
        ],
        'full_payload' => [
            'object' => 'page',
            'entry' => [
                [
                    'id' => '102261416447152',
                    'time' => 1458668856253,
                    'messaging' => [
                        [
                            'sender' => ['id' => '1234567890'],
                            'recipient' => ['id' => '102261416447152'],
                            'timestamp' => 1458668856253,
                            'read' => ['watermark' => 1458668856253, 'seq' => 38],
                        ],
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'id' => '102261416447152',
            'time' => 1458668856253,
            'messaging' => [
                [
                    'sender' => ['id' => '1234567890'],
                    'recipient' => ['id' => '102261416447152'],
                    'timestamp' => 1458668856253,
                    'read' => ['watermark' => 1458668856253, 'seq' => 38],
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'msg_delivery_read_condition', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_delivery_delivered_condition', 'payload' => 'message', 'expected' => false],
        ],
        'attributes' => [
            ['key' => 'msg_delivery_read_id', 'expected' => 1458668856253],
        ],
    ],

    'messenger_quick_reply' => [
        'process_message' => ['type' => 'button', 'sender' => 0],
        'provider' => 'Facebook Messenger',
        'description' => 'Quick reply button click',
        'conditions' => [
            'messages' => 'entry',
            'main_cond' => 'object=page',
            'msg_cond' => 'messaging.0.message.text=__exists__',
            'msg_btn_cond_1' => 'messaging.0.message.quick_reply.payload=__exists__',
            'msg_btn_cond_2' => 'messaging.0.postback.payload=__exists__',
            'msg_btn_payload_1' => 'messaging.0.message.quick_reply.payload',
        ],
        'full_payload' => [
            'object' => 'page',
            'entry' => [
                [
                    'id' => '102261416447152',
                    'time' => 1458692752478,
                    'messaging' => [
                        [
                            'sender' => ['id' => '1234567890'],
                            'recipient' => ['id' => '102261416447152'],
                            'timestamp' => 1458692752478,
                            'message' => [
                                'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
                                'text' => 'Yes',
                                'quick_reply' => ['payload' => 'DEVELOPER_DEFINED_PAYLOAD'],
                            ],
                        ],
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'id' => '102261416447152',
            'time' => 1458692752478,
            'messaging' => [
                [
                    'sender' => ['id' => '1234567890'],
                    'recipient' => ['id' => '102261416447152'],
                    'timestamp' => 1458692752478,
                    'message' => [
                        'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
                        'text' => 'Yes',
                        'quick_reply' => ['payload' => 'DEVELOPER_DEFINED_PAYLOAD'],
                    ],
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'msg_cond', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_btn_cond_1', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_btn_cond_2', 'payload' => 'message', 'expected' => false],
        ],
        'attributes' => [
            ['key' => 'msg_btn_payload_1', 'expected' => 'DEVELOPER_DEFINED_PAYLOAD'],
        ],
    ],

    'messenger_postback' => [
        'process_message' => ['type' => 'button', 'sender' => 0],
        'provider' => 'Facebook Messenger',
        'description' => 'Postback button click',
        'conditions' => [
            'messages' => 'entry',
            'main_cond' => 'object=page',
            'msg_cond' => 'messaging.0.message.text=__exists__',
            'msg_btn_cond_1' => 'messaging.0.message.quick_reply.payload=__exists__',
            'msg_btn_cond_2' => 'messaging.0.postback.payload=__exists__',
            'msg_btn_payload_2' => 'messaging.0.postback.payload',
        ],
        'full_payload' => [
            'object' => 'page',
            'entry' => [
                [
                    'id' => '102261416447152',
                    'time' => 1458692752478,
                    'messaging' => [
                        [
                            'sender' => ['id' => '1234567890'],
                            'recipient' => ['id' => '102261416447152'],
                            'timestamp' => 1458692752478,
                            'postback' => [
                                'title' => 'Bookmark',
                                'payload' => 'DEVELOPER_DEFINED_PAYLOAD',
                            ],
                        ],
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'id' => '102261416447152',
            'time' => 1458692752478,
            'messaging' => [
                [
                    'sender' => ['id' => '1234567890'],
                    'recipient' => ['id' => '102261416447152'],
                    'timestamp' => 1458692752478,
                    'postback' => [
                        'title' => 'Bookmark',
                        'payload' => 'DEVELOPER_DEFINED_PAYLOAD',
                    ],
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'msg_btn_cond_2', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_btn_cond_1', 'payload' => 'message', 'expected' => false],
            ['field' => 'msg_cond', 'payload' => 'message', 'expected' => false],
        ],
        'attributes' => [
            ['key' => 'msg_btn_payload_2', 'expected' => 'DEVELOPER_DEFINED_PAYLOAD'],
        ],
    ],

    'messenger_image' => [
        'process_message' => ['type' => 'img', 'sender' => 0],
        'provider' => 'Facebook Messenger',
        'description' => 'Incoming image attachment',
        'conditions' => [
            'messages' => 'entry',
            'main_cond' => 'object=page',
            'msg_cond' => 'messaging.0.message.text=__exists__',
            'msg_cond_img' => 'messaging.0.message.attachments.0.type=image',
            'msg_cond_img_body' => 'messaging.0.message.attachments.0.payload.url',
        ],
        'full_payload' => [
            'object' => 'page',
            'entry' => [
                [
                    'id' => '102261416447152',
                    'time' => 1458692752478,
                    'messaging' => [
                        [
                            'sender' => ['id' => '1234567890'],
                            'recipient' => ['id' => '102261416447152'],
                            'timestamp' => 1458692752478,
                            'message' => [
                                'mid' => 'mid.1458696618141:b4ef9d19ec21086067',
                                'attachments' => [
                                    [
                                        'type' => 'image',
                                        'payload' => ['url' => 'https://scontent.xx.fbcdn.net/image.jpg'],
                                    ],
                                ],
                            ],
                        ],
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'id' => '102261416447152',
            'time' => 1458692752478,
            'messaging' => [
                [
                    'sender' => ['id' => '1234567890'],
                    'recipient' => ['id' => '102261416447152'],
                    'timestamp' => 1458692752478,
                    'message' => [
                        'mid' => 'mid.1458696618141:b4ef9d19ec21086067',
                        'attachments' => [
                            [
                                'type' => 'image',
                                'payload' => ['url' => 'https://scontent.xx.fbcdn.net/image.jpg'],
                            ],
                        ],
                    ],
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'msg_cond_img', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_cond', 'payload' => 'message', 'expected' => false],
            [
                'field' => 'msg_cond_img',
                'conditions' => ['msg_cond_img' => 'messaging.0.message.attachments.0.type=video'],
                'payload' => 'message',
                'expected' => false,
            ],
            [
                'field' => 'msg_cond_img',
                'conditions' => ['msg_cond_img' => 'messaging.0.message.attachments.0.type=image,video'],
                'payload' => 'message',
                'expected' => true,
                'note' => 'comma separated attachment types act as OR',
            ],
            [
                'field' => 'msg_cond_img',
                'conditions' => ['msg_cond_img' => 'messaging.0.message.attachments.0.type=sticker,image'],
                'payload' => 'message',
                'expected' => true,
                'note' => 'comma list order does not matter',
            ],
            [
                'field' => 'msg_cond_img',
                'conditions' => ['msg_cond_img' => 'messaging.0.message.attachments.0.type=video,audio,file'],
                'payload' => 'message',
                'expected' => false,
            ],
        ],
        'attributes' => [
            ['key' => 'msg_cond_img_body', 'expected' => 'https://scontent.xx.fbcdn.net/image.jpg'],
        ],
    ],

    'messenger_reaction' => [
        'process_message' => ['type' => 'text', 'sender' => 0, 'note' => 'no msg_cond configured, defaults to text'],
        'provider' => 'Facebook Messenger',
        'description' => 'Message reaction',
        'conditions' => [
            'messages' => 'entry',
            'main_cond' => 'object=page',
            'msg_delivery_reaction_id' => 'messaging.0.reaction.mid',
            'msg_delivery_reaction_condition' => 'messaging.0.reaction.action=react',
            'msg_delivery_reaction_location' => 'messaging.0.reaction.emoji',
            'msg_delivery_un_reaction_condition' => 'messaging.0.reaction.action=unreact',
        ],
        'full_payload' => [
            'object' => 'page',
            'entry' => [
                [
                    'id' => '102261416447152',
                    'time' => 1458692752478,
                    'messaging' => [
                        [
                            'sender' => ['id' => '1234567890'],
                            'recipient' => ['id' => '102261416447152'],
                            'timestamp' => 1458692752478,
                            'reaction' => [
                                'mid' => 'mid.1458696618141:b4ef9d19ec21086067',
                                'action' => 'react',
                                'emoji' => '😍',
                                'reacted_at' => 1458692752478,
                            ],
                        ],
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'id' => '102261416447152',
            'time' => 1458692752478,
            'messaging' => [
                [
                    'sender' => ['id' => '1234567890'],
                    'recipient' => ['id' => '102261416447152'],
                    'timestamp' => 1458692752478,
                    'reaction' => [
                        'mid' => 'mid.1458696618141:b4ef9d19ec21086067',
                        'action' => 'react',
                        'emoji' => '😍',
                        'reacted_at' => 1458692752478,
                    ],
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'msg_delivery_reaction_condition', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_delivery_un_reaction_condition', 'payload' => 'message', 'expected' => false],
        ],
        'attributes' => [
            ['key' => 'msg_delivery_reaction_id', 'expected' => 'mid.1458696618141:b4ef9d19ec21086067'],
            ['key' => 'msg_delivery_reaction_location', 'expected' => '😍'],
        ],
    ],

    // ---------------------------------------------------------------------
    // Instagram (Messenger platform shape, object=instagram)
    // https://github.com/LiveHelperChat/fbmessenger/tree/master/doc/instagram
    // ---------------------------------------------------------------------
    'instagram_text' => [
        'process_message' => ['type' => 'text', 'sender' => 0],
        'provider' => 'Instagram',
        'description' => 'Incoming visitor text message',
        'conditions' => [
            'messages' => 'entry',
            'main_cond' => 'object=instagram',
            'nick' => 'messaging.0.sender.id',
            'chat_id' => 'messaging.0.sender.id',
            'chat_id_2' => 'messaging.0.recipient.id',
            'chat_id_switch' => 'messaging.0.message.is_echo=true',
            'msg_cond' => 'messaging.0.message.text=__exists__',
            'msg_cond_op' => 'messaging.0.message.is_echo=true',
        ],
        'full_payload' => [
            'object' => 'instagram',
            'entry' => [
                [
                    'id' => '17841405309211844',
                    'time' => 1458692752478,
                    'messaging' => [
                        [
                            'sender' => ['id' => '12334'],
                            'recipient' => ['id' => '23245'],
                            'timestamp' => 1458692752478,
                            'message' => [
                                'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
                                'text' => 'Hello from Instagram',
                            ],
                        ],
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'id' => '17841405309211844',
            'time' => 1458692752478,
            'messaging' => [
                [
                    'sender' => ['id' => '12334'],
                    'recipient' => ['id' => '23245'],
                    'timestamp' => 1458692752478,
                    'message' => [
                        'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
                        'text' => 'Hello from Instagram',
                    ],
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'main_cond', 'payload' => 'full', 'expected' => true],
            ['field' => 'msg_cond', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_cond_op', 'payload' => 'message', 'expected' => false],
            [
                'field' => 'main_cond',
                'conditions' => ['main_cond' => 'object=page'],
                'payload' => 'full',
                'expected' => false,
                'note' => 'Messenger condition must not match an Instagram payload',
            ],
        ],
        'attributes' => [
            ['key' => 'chat_id', 'expected' => '12334'],
            ['key' => 'chat_id_2', 'expected' => '23245'],
        ],
    ],

    'instagram_reaction' => [
        'process_message' => ['type' => 'text', 'sender' => 0, 'note' => 'no msg_cond configured, defaults to text'],
        'provider' => 'Instagram',
        'description' => 'Message reaction',
        'conditions' => [
            'messages' => 'entry',
            'main_cond' => 'object=instagram',
            'msg_delivery_reaction_id' => 'messaging.0.reaction.mid',
            'msg_delivery_reaction_condition' => 'messaging.0.reaction.action=react',
            'msg_delivery_un_reaction_condition' => 'messaging.0.reaction.action=unreact',
            'msg_delivery_reaction_location' => 'messaging.0.reaction.emoji',
        ],
        'full_payload' => [
            'object' => 'instagram',
            'entry' => [
                [
                    'id' => '17841405309211844',
                    'time' => 1458692752478,
                    'messaging' => [
                        [
                            'sender' => ['id' => '12334'],
                            'recipient' => ['id' => '23245'],
                            'timestamp' => 1458692752478,
                            'reaction' => [
                                'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
                                'action' => 'react',
                                'emoji' => '👍',
                            ],
                        ],
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'id' => '17841405309211844',
            'time' => 1458692752478,
            'messaging' => [
                [
                    'sender' => ['id' => '12334'],
                    'recipient' => ['id' => '23245'],
                    'timestamp' => 1458692752478,
                    'reaction' => [
                        'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
                        'action' => 'react',
                        'emoji' => '👍',
                    ],
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'msg_delivery_reaction_condition', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_delivery_un_reaction_condition', 'payload' => 'message', 'expected' => false],
        ],
        'attributes' => [
            ['key' => 'msg_delivery_reaction_location', 'expected' => '👍'],
        ],
    ],

    // ---------------------------------------------------------------------
    // WhatsApp Cloud API
    // https://github.com/LiveHelperChat/fbmessenger/tree/master/doc/whatsapp
    // ---------------------------------------------------------------------
    'whatsapp_text' => [
        'process_message' => ['type' => 'text', 'sender' => 0],
        'provider' => 'WhatsApp',
        'description' => 'Incoming visitor text message',
        'conditions' => [
            'messages' => 'entry',
            'main_cond' => 'object=whatsapp_business_account',
            'nick' => 'changes.0.value.contacts.0.profile.name',
            'phone' => 'changes.0.value.messages.0.from',
            'chat_id' => 'changes.0.value.contacts.0.user_id',
            'chat_id_2' => 'changes.0.value.metadata.phone_number_id',
            'msg_cond' => 'changes.0.field=messages',
            'msg_cond_2' => 'changes.0.value.messages.0.type=contacts',
            'msg_cond_img' => 'changes.0.value.messages.0.type=image',
            'msg_body' => '{{msg.changes.0.value.messages.0.text.body}}',
        ],
        'full_payload' => [
            'object' => 'whatsapp_business_account',
            'entry' => [
                [
                    'id' => '102290129340398',
                    'changes' => [
                        [
                            'value' => [
                                'messaging_product' => 'whatsapp',
                                'metadata' => [
                                    'display_phone_number' => '16505551111',
                                    'phone_number_id' => '123456123456',
                                ],
                                'contacts' => [
                                    [
                                        'profile' => ['name' => 'NAME'],
                                        'wa_id' => '16315551181',
                                        'user_id' => 'US.13491208655302741918',
                                    ],
                                ],
                                'messages' => [
                                    [
                                        'from' => '16315551181',
                                        'id' => 'wamid.HBgLMTYzMTU1NTExODE',
                                        'timestamp' => '1603059201',
                                        'text' => ['body' => 'Hello this is an answer'],
                                        'type' => 'text',
                                    ],
                                ],
                            ],
                            'field' => 'messages',
                        ],
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'id' => '102290129340398',
            'changes' => [
                [
                    'value' => [
                        'messaging_product' => 'whatsapp',
                        'metadata' => [
                            'display_phone_number' => '16505551111',
                            'phone_number_id' => '123456123456',
                        ],
                        'contacts' => [
                            [
                                'profile' => ['name' => 'NAME'],
                                'wa_id' => '16315551181',
                                'user_id' => 'US.13491208655302741918',
                            ],
                        ],
                        'messages' => [
                            [
                                'from' => '16315551181',
                                'id' => 'wamid.HBgLMTYzMTU1NTExODE',
                                'timestamp' => '1603059201',
                                'text' => ['body' => 'Hello this is an answer'],
                                'type' => 'text',
                            ],
                        ],
                    ],
                    'field' => 'messages',
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'main_cond', 'payload' => 'full', 'expected' => true],
            ['field' => 'msg_cond', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_cond_img', 'payload' => 'message', 'expected' => false],
            ['field' => 'msg_cond_2', 'payload' => 'message', 'expected' => false],
        ],
        'attributes' => [
            ['key' => 'phone', 'expected' => '16315551181'],
            ['key' => 'chat_id', 'expected' => 'US.13491208655302741918'],
            ['key' => 'chat_id_2', 'expected' => '123456123456'],
            ['key' => 'nick', 'expected' => 'NAME'],
        ],
    ],

    'whatsapp_image' => [
        'process_message' => ['type' => 'img', 'sender' => 0],
        'provider' => 'WhatsApp',
        'description' => 'Incoming image message',
        'conditions' => [
            'messages' => 'entry',
            'main_cond' => 'object=whatsapp_business_account',
            'msg_cond' => 'changes.0.value.messages.0.type=text',
            'msg_cond_img' => 'changes.0.value.messages.0.type=image',
            // Cloud API nests mime_type under the media object. The doc config used
            // "changes.0.value.messages.0.mime_type" which does not resolve on real payloads.
            'msg_cond_img_mime_type' => 'changes.0.value.messages.0.image.mime_type',
        ],
        'full_payload' => [
            'object' => 'whatsapp_business_account',
            'entry' => [
                [
                    'id' => '102290129340398',
                    'changes' => [
                        [
                            'value' => [
                                'messaging_product' => 'whatsapp',
                                'metadata' => [
                                    'display_phone_number' => '16505551111',
                                    'phone_number_id' => '123456123456',
                                ],
                                'messages' => [
                                    [
                                        'from' => '16315551181',
                                        'id' => 'wamid.HBgLMTYzMTU1NTExODE',
                                        'timestamp' => '1603059201',
                                        'type' => 'image',
                                        'image' => [
                                            'mime_type' => 'image/jpeg',
                                            'sha256' => 'abc123',
                                            'id' => 'IMAGE_ID',
                                            'caption' => 'A caption',
                                        ],
                                    ],
                                ],
                            ],
                            'field' => 'messages',
                        ],
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'id' => '102290129340398',
            'changes' => [
                [
                    'value' => [
                        'messaging_product' => 'whatsapp',
                        'metadata' => [
                            'display_phone_number' => '16505551111',
                            'phone_number_id' => '123456123456',
                        ],
                        'messages' => [
                            [
                                'from' => '16315551181',
                                'id' => 'wamid.HBgLMTYzMTU1NTExODE',
                                'timestamp' => '1603059201',
                                'type' => 'image',
                                'image' => [
                                    'mime_type' => 'image/jpeg',
                                    'sha256' => 'abc123',
                                    'id' => 'IMAGE_ID',
                                    'caption' => 'A caption',
                                ],
                            ],
                        ],
                    ],
                    'field' => 'messages',
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'msg_cond_img', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_cond', 'payload' => 'message', 'expected' => false],
            [
                'field' => 'msg_cond_img',
                'conditions' => ['msg_cond_img' => 'changes.0.value.messages.0.type=image,sticker'],
                'payload' => 'message',
                'expected' => true,
                'note' => 'comma separated media types act as OR',
            ],
            [
                'field' => 'msg_cond_img',
                'conditions' => ['msg_cond_img' => 'changes.0.value.messages.0.type=sticker,audio'],
                'payload' => 'message',
                'expected' => false,
            ],
            [
                'field' => 'msg_cond_img',
                'conditions' => ['msg_cond_img' => 'changes.0.value.messages.0.type=image,'],
                'payload' => 'message',
                'expected' => true,
                'note' => 'trailing comma (as used by the shipped WhatsApp doc config) is tolerated',
            ],
        ],
        'attributes' => [
            ['key' => 'msg_cond_img_mime_type', 'expected' => 'image/jpeg'],
        ],
    ],

    'whatsapp_delivery' => [
        'process_message' => ['type' => 'text', 'sender' => 0, 'note' => 'no msg_cond configured, defaults to text'],
        'provider' => 'WhatsApp',
        'description' => 'Delivery status callback',
        'conditions' => [
            'messages' => 'entry',
            'main_cond' => 'object=whatsapp_business_account',
            'msg_delivery_delivered_id' => 'changes.0.value.statuses.0.id',
            'msg_delivery_delivered_condition' => 'changes.0.value.statuses.0.status=delivered',
            'msg_delivery_read_condition' => 'changes.0.value.statuses.0.status=read',
            'msg_delivery_multi_condition' => 'changes.0.value.statuses.0.status=sent,delivered,read',
            'msg_delivery_failed_condition' => 'changes.0.value.statuses.0.status=failed',
        ],
        'full_payload' => [
            'object' => 'whatsapp_business_account',
            'entry' => [
                [
                    'id' => '102290129340398',
                    'changes' => [
                        [
                            'value' => [
                                'messaging_product' => 'whatsapp',
                                'metadata' => [
                                    'display_phone_number' => '16505551111',
                                    'phone_number_id' => '123456123456',
                                ],
                                'statuses' => [
                                    [
                                        'id' => 'wamid.HBgLMTYzMTU1NTExODE',
                                        'status' => 'delivered',
                                        'timestamp' => '1603059203',
                                        // Cloud API sends recipient_id; recipient_user_id is
                                        // what the shipped Live Helper Chat config references.
                                        'recipient_id' => '16315551181',
                                        'recipient_user_id' => '16315551181',
                                    ],
                                ],
                            ],
                            'field' => 'messages',
                        ],
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'id' => '102290129340398',
            'changes' => [
                [
                    'value' => [
                        'messaging_product' => 'whatsapp',
                        'metadata' => [
                            'display_phone_number' => '16505551111',
                            'phone_number_id' => '123456123456',
                        ],
                        'statuses' => [
                            [
                                'id' => 'wamid.HBgLMTYzMTU1NTExODE',
                                'status' => 'delivered',
                                'timestamp' => '1603059203',
                                'recipient_id' => '16315551181',
                                'recipient_user_id' => '16315551181',
                            ],
                        ],
                    ],
                    'field' => 'messages',
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'msg_delivery_delivered_condition', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_delivery_read_condition', 'payload' => 'message', 'expected' => false],
            ['field' => 'msg_delivery_multi_condition', 'payload' => 'message', 'expected' => true, 'note' => 'delivered is part of sent,delivered,read'],
            ['field' => 'msg_delivery_failed_condition', 'payload' => 'message', 'expected' => false],
        ],
        'attributes' => [
            ['key' => 'msg_delivery_delivered_id', 'expected' => 'wamid.HBgLMTYzMTU1NTExODE'],
        ],
    ],

    // ---------------------------------------------------------------------
    // Generic attachment list (message.body.attachments[])
    // Ordered attachments shape used by providers that forward media as a list
    // (LINE / Bot Framework style). Verifies multi type matching such as
    // "message.body.attachments.0.type=image,sticker".
    // ---------------------------------------------------------------------
    'attachment_multi_type' => [
        'process_message' => ['type' => 'img', 'sender' => 0],
        'provider' => 'Generic attachments',
        'description' => 'Message with an ordered attachments list (image/sticker multi type condition)',
        'conditions' => [
            'messages' => '',
            'message_direct' => true,
            'main_cond' => 'event=message',
            'msg_cond_img' => 'message.body.attachments.0.type=image,sticker',
            'msg_cond_img_2' => 'message.body.attachments.1.type=image,sticker',
            'msg_cond_img_body' => 'message.body.attachments.0.url',
            'msg_cond_img_url' => 'message.body.attachments.1.url',
        ],
        'full_payload' => [
            'event' => 'message',
            'message' => [
                'id' => 'msg-1',
                'from' => 'user-1',
                'type' => 'attachment',
                'body' => [
                    'text' => 'Look at this',
                    'attachments' => [
                        ['type' => 'sticker', 'url' => 'https://cdn.example.com/sticker.webp'],
                        ['type' => 'image', 'url' => 'https://cdn.example.com/photo.jpg'],
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'event' => 'message',
            'message' => [
                'id' => 'msg-1',
                'from' => 'user-1',
                'type' => 'attachment',
                'body' => [
                    'text' => 'Look at this',
                    'attachments' => [
                        ['type' => 'sticker', 'url' => 'https://cdn.example.com/sticker.webp'],
                        ['type' => 'image', 'url' => 'https://cdn.example.com/photo.jpg'],
                    ],
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'main_cond', 'payload' => 'full', 'expected' => true],
            ['field' => 'msg_cond_img', 'payload' => 'message', 'expected' => true, 'note' => 'sticker is in image,sticker'],
            ['field' => 'msg_cond_img_2', 'payload' => 'message', 'expected' => true, 'note' => 'second attachment is image'],
            [
                'field' => 'msg_cond_img',
                'conditions' => ['msg_cond_img' => 'message.body.attachments.0.type=sticker,image'],
                'payload' => 'message',
                'expected' => true,
                'note' => 'comma list order does not matter',
            ],
            [
                'field' => 'msg_cond_img',
                'conditions' => ['msg_cond_img' => 'message.body.attachments.0.type=video,audio'],
                'payload' => 'message',
                'expected' => false,
            ],
            [
                'field' => 'msg_cond_img',
                'conditions' => ['msg_cond_img' => 'message.body.attachments.0.type=image, sticker'],
                'payload' => 'message',
                'expected' => false,
                'note' => 'values are not trimmed, a space after the comma prevents a match',
            ],
            [
                'field' => 'msg_cond_img_2',
                'conditions' => ['msg_cond_img_2' => 'message.body.attachments.1.type=file,document'],
                'payload' => 'message',
                'expected' => false,
            ],
        ],
        'attributes' => [
            ['key' => 'msg_cond_img_body', 'expected' => 'https://cdn.example.com/sticker.webp'],
            ['key' => 'msg_cond_img_url', 'expected' => 'https://cdn.example.com/photo.jpg'],
        ],
    ],

    // ---------------------------------------------------------------------
    // Telegram
    // extension/lhctelegram/doc/telegram/incoming-webhook.json
    // ---------------------------------------------------------------------
    'telegram_text' => [
        'process_message' => ['type' => 'text', 'sender' => 0],
        'provider' => 'Telegram',
        'description' => 'Incoming text message (message_direct=true, messages empty)',
        'conditions' => [
            'messages' => '',
            'message_direct' => true,
            'nick' => 'message.from.first_name|||message.from.last_name',
            'chat_id' => 'message.chat.id|||callback_query.message.chat.id|||edited_message.chat.id',
            'msg_cond' => 'message.text=__exists__',
            'msg_cond_img' => 'message.photo=__exists__',
            'msg_cond_attachments' => 'message.document=__exists__',
        ],
        'full_payload' => [
            'update_id' => 123456789,
            'message' => [
                'message_id' => 1,
                'from' => [
                    'id' => 1087968824,
                    'is_bot' => false,
                    'first_name' => 'John',
                    'last_name' => 'Doe',
                    'username' => 'johndoe',
                    'language_code' => 'en',
                ],
                'chat' => [
                    'id' => 777000,
                    'first_name' => 'John',
                    'last_name' => 'Doe',
                    'username' => 'johndoe',
                    'type' => 'private',
                ],
                'date' => 1600000000,
                'text' => 'Hello, bot!',
            ],
        ],
        'message_payload' => [
            'update_id' => 123456789,
            'message' => [
                'message_id' => 1,
                'from' => [
                    'id' => 1087968824,
                    'is_bot' => false,
                    'first_name' => 'John',
                    'last_name' => 'Doe',
                    'username' => 'johndoe',
                    'language_code' => 'en',
                ],
                'chat' => [
                    'id' => 777000,
                    'first_name' => 'John',
                    'last_name' => 'Doe',
                    'username' => 'johndoe',
                    'type' => 'private',
                ],
                'date' => 1600000000,
                'text' => 'Hello, bot!',
            ],
        ],
        'expectations' => [
            ['field' => 'msg_cond', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_cond_img', 'payload' => 'message', 'expected' => false],
            ['field' => 'msg_cond_attachments', 'payload' => 'message', 'expected' => false],
        ],
        'attributes' => [
            ['key' => 'nick', 'expected' => 'John'],
            // Callers must pre-split ||| candidates before calling extractAttribute.
            ['key' => 'chat_id', 'conditions' => ['chat_id' => 'message.chat.id'], 'expected' => 777000],
        ],
    ],

    'telegram_photo' => [
        'process_message' => ['type' => 'img', 'sender' => 0],
        'provider' => 'Telegram',
        'description' => 'Incoming photo message (photo is an array of sizes)',
        'conditions' => [
            'messages' => '',
            'message_direct' => true,
            'nick' => 'message.from.first_name',
            'chat_id' => 'message.chat.id',
            'msg_cond' => 'message.text=__exists__',
            'msg_cond_img' => 'message.photo=__exists__',
            'msg_cond_img_file_name' => 'message.photo___array_pop.file_id',
        ],
        'full_payload' => [
            'update_id' => 123456791,
            'message' => [
                'message_id' => 2,
                'from' => [
                    'id' => 1087968824,
                    'is_bot' => false,
                    'first_name' => 'John',
                    'last_name' => 'Doe',
                ],
                'chat' => [
                    'id' => 777000,
                    'first_name' => 'John',
                    'type' => 'private',
                ],
                'date' => 1600000010,
                'caption' => 'Look at this',
                'photo' => [
                    ['file_id' => 'small_file_id', 'file_unique_id' => 'u1', 'width' => 90, 'height' => 60, 'file_size' => 1234],
                    ['file_id' => 'medium_file_id', 'file_unique_id' => 'u2', 'width' => 320, 'height' => 240, 'file_size' => 12345],
                    ['file_id' => 'large_file_id', 'file_unique_id' => 'u3', 'width' => 800, 'height' => 600, 'file_size' => 123456],
                ],
            ],
        ],
        'message_payload' => [
            'update_id' => 123456791,
            'message' => [
                'message_id' => 2,
                'from' => [
                    'id' => 1087968824,
                    'is_bot' => false,
                    'first_name' => 'John',
                    'last_name' => 'Doe',
                ],
                'chat' => [
                    'id' => 777000,
                    'first_name' => 'John',
                    'type' => 'private',
                ],
                'date' => 1600000010,
                'caption' => 'Look at this',
                'photo' => [
                    ['file_id' => 'small_file_id', 'file_unique_id' => 'u1', 'width' => 90, 'height' => 60, 'file_size' => 1234],
                    ['file_id' => 'medium_file_id', 'file_unique_id' => 'u2', 'width' => 320, 'height' => 240, 'file_size' => 12345],
                    ['file_id' => 'large_file_id', 'file_unique_id' => 'u3', 'width' => 800, 'height' => 600, 'file_size' => 123456],
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'msg_cond_img', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_cond', 'payload' => 'message', 'expected' => false],
        ],
        'attributes' => [
            ['key' => 'msg_cond_img_file_name', 'expected' => 'large_file_id'],
        ],
    ],

    'telegram_callback' => [
        'process_message' => ['type' => null, 'note' => 'msg_cond message.text=__exists__ does not match a callback_query'],
        'provider' => 'Telegram',
        'description' => 'Callback query (inline keyboard button)',
        'conditions' => [
            'messages' => '',
            'message_direct' => true,
            'nick' => 'callback_query.from.first_name|||callback_query.from.last_name',
            'chat_id' => 'callback_query.message.chat.id',
            'msg_cond' => 'message.text=__exists__',
        ],
        'full_payload' => [
            'update_id' => 123456792,
            'callback_query' => [
                'id' => '4382bfdwdsb323b2d9',
                'from' => [
                    'id' => 1087968824,
                    'is_bot' => false,
                    'first_name' => 'John',
                    'last_name' => 'Doe',
                ],
                'message' => [
                    'message_id' => 10,
                    'from' => ['id' => 777000, 'is_bot' => true, 'first_name' => 'MyBot'],
                    'chat' => ['id' => 777000, 'first_name' => 'John', 'type' => 'private'],
                    'date' => 1600000100,
                    'text' => 'Choose an option',
                ],
                'chat_instance' => '1511198522243756849',
                'data' => 'option_a',
            ],
        ],
        'message_payload' => [
            'update_id' => 123456792,
            'callback_query' => [
                'id' => '4382bfdwdsb323b2d9',
                'from' => [
                    'id' => 1087968824,
                    'is_bot' => false,
                    'first_name' => 'John',
                    'last_name' => 'Doe',
                ],
                'message' => [
                    'message_id' => 10,
                    'from' => ['id' => 777000, 'is_bot' => true, 'first_name' => 'MyBot'],
                    'chat' => ['id' => 777000, 'first_name' => 'John', 'type' => 'private'],
                    'date' => 1600000100,
                    'text' => 'Choose an option',
                ],
                'chat_instance' => '1511198522243756849',
                'data' => 'option_a',
            ],
        ],
        'expectations' => [
            ['field' => 'msg_cond', 'payload' => 'message', 'expected' => false],
            [
                'field' => 'msg_cond',
                'conditions' => ['msg_cond' => 'callback_query.data=__exists__'],
                'payload' => 'message',
                'expected' => true,
            ],
        ],
        'attributes' => [
            ['key' => 'nick', 'expected' => 'John'],
            ['key' => 'chat_id', 'expected' => 777000],
        ],
    ],

    // ---------------------------------------------------------------------
    // Telegram main_cond negation (message.chat.type!=supergroup)
    // extension/lhctelegram/doc/telegram/incoming-webhook.json
    // ---------------------------------------------------------------------
    'telegram_main_cond_private' => [
        'provider' => 'Telegram',
        'description' => 'Private chat message accepted by main_cond message.chat.type!=supergroup',
        'conditions' => $telegramMainCondConditions,
        'full_payload' => [
            'update_id' => 532262440,
            'message' => [
                'message_id' => 3193,
                'from' => [
                    'id' => 441347276,
                    'is_bot' => false,
                    'first_name' => 'Remigijus',
                    'last_name' => 'Kiminas',
                    'username' => 'remdex',
                    'language_code' => 'en',
                ],
                'chat' => [
                    'id' => 441347276,
                    'first_name' => 'Remigijus',
                    'last_name' => 'Kiminas',
                    'username' => 'remdex',
                    'type' => 'private',
                ],
                'date' => 1788949109,
                'text' => 'Fresh start',
            ],
        ],
        'message_payload' => [
            'update_id' => 532262440,
            'message' => [
                'message_id' => 3193,
                'from' => [
                    'id' => 441347276,
                    'is_bot' => false,
                    'first_name' => 'Remigijus',
                    'last_name' => 'Kiminas',
                    'username' => 'remdex',
                    'language_code' => 'en',
                ],
                'chat' => [
                    'id' => 441347276,
                    'first_name' => 'Remigijus',
                    'last_name' => 'Kiminas',
                    'username' => 'remdex',
                    'type' => 'private',
                ],
                'date' => 1788949109,
                'text' => 'Fresh start',
            ],
        ],
        'expectations' => [
            ['field' => 'main_cond', 'payload' => 'full', 'expected' => true, 'note' => 'chat type private differs from supergroup'],
            ['field' => 'main_cond', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_cond', 'payload' => 'full', 'expected' => true],
            ['field' => 'msg_btn_cond_1', 'payload' => 'full', 'expected' => false],
            [
                'field' => 'main_cond',
                'conditions' => ['main_cond' => 'message.chat.type!=private'],
                'payload' => 'full',
                'expected' => false,
                'note' => 'negated condition fails when the value is equal',
            ],
        ],
        'attributes' => [
            ['key' => 'nick', 'conditions' => ['nick' => 'message.from.first_name'], 'expected' => 'Remigijus'],
            ['key' => 'chat_id', 'conditions' => ['chat_id' => 'message.chat.id'], 'expected' => 441347276],
        ],
    ],

    'telegram_main_cond_callback' => [
        'provider' => 'Telegram',
        'description' => 'Callback query accepted by main_cond message.chat.type!=supergroup (attribute is missing)',
        'conditions' => $telegramMainCondConditions,
        'full_payload' => [
            'update_id' => 912345678,
            'callback_query' => [
                'id' => '4122368201564890123',
                'from' => [
                    'id' => 512345678,
                    'is_bot' => false,
                    'first_name' => 'John',
                    'language_code' => 'en',
                ],
                'message' => [
                    'message_id' => 1842,
                    'from' => [
                        'id' => 7012345678,
                        'is_bot' => true,
                        'first_name' => 'SmartDiag',
                        'username' => 'smartdiag_bot',
                    ],
                    'chat' => [
                        'id' => 512345678,
                        'first_name' => 'John',
                        'type' => 'private',
                    ],
                    'date' => 1760280000,
                    'text' => 'Choose an option',
                    'reply_markup' => [
                        'inline_keyboard' => [
                            [
                                ['text' => 'Yes', 'callback_data' => 'trigger__2021__a1b2c3__98765'],
                            ],
                        ],
                    ],
                ],
                'chat_instance' => '-3456789012345678901',
                'data' => 'trigger__2021__a1b2c3__98765',
            ],
        ],
        'message_payload' => [
            'update_id' => 912345678,
            'callback_query' => [
                'id' => '4122368201564890123',
                'from' => [
                    'id' => 512345678,
                    'is_bot' => false,
                    'first_name' => 'John',
                    'language_code' => 'en',
                ],
                'message' => [
                    'message_id' => 1842,
                    'from' => [
                        'id' => 7012345678,
                        'is_bot' => true,
                        'first_name' => 'SmartDiag',
                        'username' => 'smartdiag_bot',
                    ],
                    'chat' => [
                        'id' => 512345678,
                        'first_name' => 'John',
                        'type' => 'private',
                    ],
                    'date' => 1760280000,
                    'text' => 'Choose an option',
                    'reply_markup' => [
                        'inline_keyboard' => [
                            [
                                ['text' => 'Yes', 'callback_data' => 'trigger__2021__a1b2c3__98765'],
                            ],
                        ],
                    ],
                ],
                'chat_instance' => '-3456789012345678901',
                'data' => 'trigger__2021__a1b2c3__98765',
            ],
        ],
        'expectations' => [
            ['field' => 'main_cond', 'payload' => 'full', 'expected' => true, 'note' => 'no root message.chat.type => negated condition is met'],
            ['field' => 'main_cond', 'payload' => 'message', 'expected' => true],
            ['field' => 'msg_cond', 'payload' => 'full', 'expected' => false, 'note' => 'callback query has no root message.text'],
            ['field' => 'msg_btn_cond_1', 'payload' => 'full', 'expected' => true],
            [
                'field' => 'main_cond',
                'conditions' => ['main_cond' => 'message.chat.type=supergroup'],
                'payload' => 'full',
                'expected' => false,
                'note' => 'the positive form of the same condition would drop callback queries',
            ],
        ],
        'attributes' => [
            ['key' => 'nick', 'conditions' => ['nick' => 'callback_query.from.first_name'], 'expected' => 'John'],
            ['key' => 'chat_id', 'conditions' => ['chat_id' => 'callback_query.message.chat.id'], 'expected' => 512345678],
        ],
    ],

    'telegram_main_cond_supergroup' => [
        'provider' => 'Telegram',
        'description' => 'Supergroup message ignored by main_cond message.chat.type!=supergroup',
        'conditions' => $telegramMainCondConditions,
        'full_payload' => [
            'update_id' => 586105899,
            'message' => [
                'message_id' => 39,
                'from' => [
                    'id' => 5071884088,
                    'is_bot' => false,
                    'first_name' => 'M',
                    'last_name' => 'R',
                    'username' => 'rajkicc',
                    'language_code' => 'en',
                ],
                'chat' => [
                    'id' => -2071698592261,
                    'title' => 'Casino eXtreme Official Channel',
                    'is_direct_messages' => true,
                    'type' => 'supergroup',
                ],
                'date' => 1791962035,
                'text' => 'hello',
                'direct_messages_topic' => [
                    'topic_id' => 5071884088,
                    'user' => [
                        'id' => 5071884088,
                        'is_bot' => false,
                        'first_name' => 'M',
                        'last_name' => 'R',
                        'username' => 'rajkicc',
                        'language_code' => 'en',
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'update_id' => 586105899,
            'message' => [
                'message_id' => 39,
                'from' => [
                    'id' => 5071884088,
                    'is_bot' => false,
                    'first_name' => 'M',
                    'last_name' => 'R',
                    'username' => 'rajkicc',
                    'language_code' => 'en',
                ],
                'chat' => [
                    'id' => -2071698592261,
                    'title' => 'Casino eXtreme Official Channel',
                    'is_direct_messages' => true,
                    'type' => 'supergroup',
                ],
                'date' => 1791962035,
                'text' => 'hello',
                'direct_messages_topic' => [
                    'topic_id' => 5071884088,
                    'user' => [
                        'id' => 5071884088,
                        'is_bot' => false,
                        'first_name' => 'M',
                        'last_name' => 'R',
                        'username' => 'rajkicc',
                        'language_code' => 'en',
                    ],
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'main_cond', 'payload' => 'full', 'expected' => false, 'note' => 'chat type equals supergroup => negated condition fails, webhook is ignored'],
            ['field' => 'main_cond', 'payload' => 'message', 'expected' => false],
            ['field' => 'msg_cond', 'payload' => 'full', 'expected' => true, 'note' => 'message conditions alone would still match, main_cond is what rejects it'],
            [
                'field' => 'main_cond',
                'conditions' => ['main_cond' => 'message.chat.type!=supergroup,group'],
                'payload' => 'full',
                'expected' => false,
                'note' => 'negated comma list: supergroup is in the list',
            ],
            [
                'field' => 'main_cond',
                'conditions' => ['main_cond' => 'message.chat.title!=Casino eXtreme Official Channel'],
                'payload' => 'full',
                'expected' => false,
                'note' => 'negation compares the whole value, no partial matching'],
        ],
        'attributes' => [
            ['key' => 'nick', 'conditions' => ['nick' => 'message.from.first_name'], 'expected' => 'M'],
            ['key' => 'chat_id', 'conditions' => ['chat_id' => 'message.chat.id'], 'expected' => -2071698592261],
        ],
    ],

    // ---------------------------------------------------------------------
    // Viber (REST Bot API)
    // https://developers.viber.com/docs/api/rest-bot-api/#callbacks
    // ---------------------------------------------------------------------
    'viber_text' => [
        'process_message' => ['type' => 'text', 'sender' => 0],
        'provider' => 'Viber',
        'description' => 'Incoming text message',
        'conditions' => [
            'messages' => '',
            'message_direct' => true,
            'main_cond' => 'event=message',
            'nick' => 'sender.name',
            'chat_id' => 'sender.id',
            'msg_cond' => 'message.type=text',
        ],
        'full_payload' => [
            'event' => 'message',
            'timestamp' => 1457764197627,
            'message_token' => 4912661846655238145,
            'sender' => [
                'id' => '01234567890A=',
                'name' => 'John McClane',
                'avatar' => 'http://avatar.example.com',
                'country' => 'US',
                'language' => 'en',
                'api_version' => 1,
            ],
            'message' => [
                'type' => 'text',
                'text' => 'a message to the service',
                'media' => null,
                'location' => null,
                'contact' => null,
                'tracking_data' => 'tracking data',
            ],
        ],
        'message_payload' => [
            'event' => 'message',
            'timestamp' => 1457764197627,
            'message_token' => 4912661846655238145,
            'sender' => [
                'id' => '01234567890A=',
                'name' => 'John McClane',
                'avatar' => 'http://avatar.example.com',
                'country' => 'US',
                'language' => 'en',
                'api_version' => 1,
            ],
            'message' => [
                'type' => 'text',
                'text' => 'a message to the service',
                'media' => null,
                'location' => null,
                'contact' => null,
                'tracking_data' => 'tracking data',
            ],
        ],
        'expectations' => [
            ['field' => 'main_cond', 'payload' => 'full', 'expected' => true],
            ['field' => 'msg_cond', 'payload' => 'message', 'expected' => true],
            [
                'field' => 'msg_cond',
                'conditions' => ['msg_cond' => 'message.type=picture'],
                'payload' => 'message',
                'expected' => false,
            ],
            [
                'field' => 'main_cond',
                'conditions' => ['main_cond' => 'event=subscribed'],
                'payload' => 'full',
                'expected' => false,
            ],
        ],
        'attributes' => [
            ['key' => 'nick', 'expected' => 'John McClane'],
            ['key' => 'chat_id', 'expected' => '01234567890A='],
        ],
    ],

    // ---------------------------------------------------------------------
    // MAX (Max Messenger)
    // Conditions: https://github.com/LiveHelperChat/lhcmax/blob/master/doc/max/incoming-webhook.json
    // Payloads:  https://github.com/max-messenger/api-schema (Update discriminator
    //            on update_type: message_created / message_callback / bot_started)
    // ---------------------------------------------------------------------
    'max_message_created' => [
        'process_message' => ['type' => 'text', 'sender' => 0],
        'provider' => 'MAX',
        'description' => 'Incoming text message (message_created)',
        'conditions' => $maxConditions,
        'full_payload' => $maxMessageCreatedPayload,
        'message_payload' => $maxMessageCreatedPayload,
        'expectations' => [
            ['field' => 'main_cond', 'payload' => 'full', 'expected' => true, 'note' => 'message_created is in the update_type=...,...,... list'],
            ['field' => 'msg_cond', 'payload' => 'full', 'expected' => true],
            ['field' => 'msg_cond_2', 'payload' => 'full', 'expected' => false, 'note' => 'not bot_started'],
            ['field' => 'msg_cond_img', 'payload' => 'full', 'expected' => false],
            ['field' => 'msg_cond_img_2', 'payload' => 'full', 'expected' => false],
            ['field' => 'msg_cond_img_3', 'payload' => 'full', 'expected' => false],
            ['field' => 'msg_cond_attachments', 'payload' => 'full', 'expected' => false],
            ['field' => 'msg_cond_img_body', 'payload' => 'full', 'expected' => false],
            ['field' => 'msg_btn_cond_1', 'payload' => 'full', 'expected' => false],
            [
                'field' => 'main_cond',
                'conditions' => ['main_cond' => 'update_type=message_callback'],
                'payload' => 'full',
                'expected' => false,
            ],
            [
                'field' => 'main_cond',
                'conditions' => ['main_cond' => 'update_type=message_edited,message_removed'],
                'payload' => 'full',
                'expected' => false,
                'note' => 'unrelated update types do not match',
            ],
        ],
        'attributes' => [
            ['key' => 'message_id', 'expected' => 'mid.0000000000000001'],
            // Callers pre-split the ||| chains, so single paths are tested here.
            ['key' => 'nick', 'conditions' => ['nick' => 'message.sender.first_name'], 'expected' => 'Иван'],
            ['key' => 'chat_id', 'conditions' => ['chat_id' => 'message.recipient.chat_id'], 'expected' => 987654321],
        ],
    ],

    'max_message_callback' => [
        'process_message' => ['type' => 'button', 'sender' => 0],
        'provider' => 'MAX',
        'description' => 'Inline keyboard button pressed (message_callback)',
        'conditions' => $maxConditions,
        'full_payload' => [
            'update_type' => 'message_callback',
            'timestamp' => 1737500140000,
            'callback' => [
                'timestamp' => 1737500140000,
                'callback_id' => 'callback-id-1',
                'payload' => 'button1 pressed',
                'user' => [
                    'user_id' => 123456789,
                    'first_name' => 'Иван',
                    'last_name' => 'Петров',
                    'username' => 'ivan_p',
                    'is_bot' => false,
                ],
            ],
            'message' => [
                'sender' => [
                    'user_id' => 987654321,
                    'first_name' => 'MyBot',
                    'is_bot' => true,
                ],
                'recipient' => [
                    'chat_id' => 987654321,
                    'chat_type' => 'dialog',
                    'user_id' => 123456789,
                ],
                'timestamp' => 1737500135000,
                'body' => [
                    'mid' => 'mid.0000000000000002',
                    'seq' => 2,
                    'text' => 'It is message with inline keyboard',
                    'attachments' => [
                        [
                            'type' => 'inline_keyboard',
                            'payload' => [
                                'buttons' => [
                                    [
                                        ['type' => 'callback', 'text' => 'Press me!', 'payload' => 'button1 pressed'],
                                    ],
                                ],
                            ],
                        ],
                    ],
                ],
            ],
        ],
        'message_payload' => [
            'update_type' => 'message_callback',
            'timestamp' => 1737500140000,
            'callback' => [
                'timestamp' => 1737500140000,
                'callback_id' => 'callback-id-1',
                'payload' => 'button1 pressed',
                'user' => [
                    'user_id' => 123456789,
                    'first_name' => 'Иван',
                    'last_name' => 'Петров',
                    'username' => 'ivan_p',
                    'is_bot' => false,
                ],
            ],
            'message' => [
                'sender' => [
                    'user_id' => 987654321,
                    'first_name' => 'MyBot',
                    'is_bot' => true,
                ],
                'recipient' => [
                    'chat_id' => 987654321,
                    'chat_type' => 'dialog',
                    'user_id' => 123456789,
                ],
                'timestamp' => 1737500135000,
                'body' => [
                    'mid' => 'mid.0000000000000002',
                    'seq' => 2,
                    'text' => 'It is message with inline keyboard',
                    'attachments' => [
                        [
                            'type' => 'inline_keyboard',
                            'payload' => [
                                'buttons' => [
                                    [
                                        ['type' => 'callback', 'text' => 'Press me!', 'payload' => 'button1 pressed'],
                                    ],
                                ],
                            ],
                        ],
                    ],
                ],
            ],
        ],
        'expectations' => [
            ['field' => 'main_cond', 'payload' => 'full', 'expected' => true],
            ['field' => 'msg_cond', 'payload' => 'full', 'expected' => false, 'note' => 'not message_created'],
            ['field' => 'msg_cond_2', 'payload' => 'full', 'expected' => false],
            ['field' => 'msg_btn_cond_1', 'payload' => 'full', 'expected' => true, 'note' => 'update_type=message_callback AND callback.payload=__exists__'],
            ['field' => 'msg_cond_img', 'payload' => 'full', 'expected' => false, 'note' => 'inline_keyboard is not image,sticker'],
            ['field' => 'msg_cond_attachments', 'payload' => 'full', 'expected' => false, 'note' => 'inline_keyboard is not file'],
            [
                'field' => 'msg_btn_cond_1',
                'conditions' => ['msg_btn_cond_1' => 'update_type=message_callback'],
                'payload' => 'full',
                'expected' => true,
            ],
        ],
        'attributes' => [
            // Callers pre-split the ||| chains, so single paths are tested here.
            ['key' => 'nick', 'conditions' => ['nick' => 'message.sender.first_name'], 'expected' => 'MyBot'],
            ['key' => 'chat_id', 'conditions' => ['chat_id' => 'message.recipient.chat_id'], 'expected' => 987654321],
            ['key' => 'msg_btn_payload_1', 'expected' => 'button1 pressed'],
            ['key' => 'msg_btn_message_id', 'expected' => 'callback-id-1'],
        ],
    ],

    'max_bot_started' => [
        'process_message' => ['type' => 'text', 'sender' => 0],
        'provider' => 'MAX',
        'description' => 'User pressed Start / deep link (bot_started)',
        'conditions' => $maxConditions,
        'full_payload' => [
            'update_type' => 'bot_started',
            'timestamp' => 1737500150000,
            'chat_id' => 987654321,
            'user' => [
                'user_id' => 123456789,
                'first_name' => 'Иван',
                'last_name' => 'Петров',
                'username' => 'ivan_p',
                'is_bot' => false,
            ],
            'payload' => 'any data meaningful to bot',
        ],
        'message_payload' => [
            'update_type' => 'bot_started',
            'timestamp' => 1737500150000,
            'chat_id' => 987654321,
            'user' => [
                'user_id' => 123456789,
                'first_name' => 'Иван',
                'last_name' => 'Петров',
                'username' => 'ivan_p',
                'is_bot' => false,
            ],
            'payload' => 'any data meaningful to bot',
        ],
        'expectations' => [
            ['field' => 'main_cond', 'payload' => 'full', 'expected' => true, 'note' => 'bot_started is in the update_type list'],
            ['field' => 'msg_cond', 'payload' => 'full', 'expected' => false],
            ['field' => 'msg_cond_2', 'payload' => 'full', 'expected' => true],
            ['field' => 'msg_cond_img', 'payload' => 'full', 'expected' => false],
            ['field' => 'msg_btn_cond_1', 'payload' => 'full', 'expected' => false, 'note' => 'no callback object'],
        ],
        'attributes' => [
            ['key' => 'nick', 'conditions' => ['nick' => 'user.first_name'], 'expected' => 'Иван'],
            ['key' => 'chat_id', 'conditions' => ['chat_id' => 'chat_id'], 'expected' => 987654321],
            ['key' => 'message_id', 'expected' => '', 'default' => ''],
        ],
    ],
];
