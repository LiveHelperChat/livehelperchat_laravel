<?php

namespace Tests\Unit;

use Mockery;

/**
 * Unit tests for erLhcoreClassModelUserDep::getOnlineOperators method
 * 
 * This test class validates the behavior of the getOnlineOperators method
 * which retrieves a list of online operators based on various filters and permissions.
 * 
 * Note: This extends LegacyTestCase which handles loading the legacy Live Helper Chat code.
 */
class ChatDurationTest extends LegacyTestCase
{
    protected function tearDown(): void
    {
        Mockery::close();
        parent::tearDown();
    }

    /**
     * Test that getOnlineOperators returns array of operators with list all permission
     */
    public function test_chat_duration()
    {
        $chat = \erLhcoreClassModelChat::fetch(1647604361, false);

        $log = [];
        $logMain = [];

        $duration = \LiveHelperChat\Helpers\ChatDuration::getChatDurationToUpdateChatID($chat, true, $log, $logMain);

        $expectedLogMain = [
            'response_times' => [
                1 => [
                    0 => 8
                ],
            ],
            'response_times_total' => [
                0 => 8
            ],
        ];

        $this->assertEquals('1 P_USER_ID -- 25 TTA -- 07:03:30 MSG_TIME', $log[7]);
        $this->assertEquals(33, $duration);
        $this->assertEquals($expectedLogMain, $logMain);

        $chat = \erLhcoreClassModelChat::fetch(1647604360, false);

        $log = [];
        $logMain = [];

        $duration = \LiveHelperChat\Helpers\ChatDuration::getChatDurationToUpdateChatID($chat, true, $log, $logMain);

        $expectedLogMain = [
            'response_times' => [
                1 => [
                    0 => 9,
                    1 => 6,
                ],
            ],
            'response_times_total' => [
                0 => 9,
                1 => 6,
            ],
        ];

        $this->assertEquals('1 P_USER_ID -- 12 TTA -- 06:12:59 MSG_TIME', $log[8]);
        $this->assertEquals(36, $duration);
        $this->assertEquals($expectedLogMain, $logMain);

        $chat = \erLhcoreClassModelChat::fetch(1647604362, false);

        $log = [];
        $logMain = [];

        $duration = \LiveHelperChat\Helpers\ChatDuration::getChatDurationToUpdateChatID($chat, true, $log, $logMain);

        $expectedLogMain = [
            'response_times' => [
                1 => [
                    0 => 7,
                    1 => 6,
                    2 => 4,
                ],
            ],
            'response_times_total' => [
                0 => 7,
                1 => 6,
                2 => 4
            ],
        ];

        $this->assertEquals('1 P_USER_ID -- 28 TTA -- 09:12:25 MSG_TIME', $log[14]);
        $this->assertEquals(38, $duration);
        $this->assertEquals($expectedLogMain, $logMain);


        $log = [];
        $logMain = [];
        $chat = \erLhcoreClassModelChat::fetch(91238);
        $duration = \LiveHelperChat\Helpers\ChatDuration::getChatDurationToUpdateChatID($chat, true, $log, $logMain);

        $this->assertEquals([], $logMain);
        $this->assertEquals([], $log);
        $this->assertEquals($duration, 0);

        $db = \ezcDbInstance::get();
        $stmt = $db->prepare("SELECT user_id   FROM `lh_chat_participant` WHERE chat_id = :chat_id");
        $stmt->bindValue(':chat_id',$chat->id);
        $stmt->execute();
        $result = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        $this->assertEquals($result, array (
            0 =>
                array (
                    'user_id' => 125,
                ),
        ));

        $log = [];
        $logMain = [];
        $logOpeartor = [];
        $chat = \erLhcoreClassModelChat::fetch(87537);
        $duration = \LiveHelperChat\Helpers\ChatDuration::getChatDurationToUpdateChatID($chat, true, $log, $logMain, $logOpeartor);

        $this->assertEquals($logOpeartor[129], 50);
        $this->assertEquals($logOpeartor[123], 410);
        $this->assertEquals($duration, 464);

        $this->assertEquals(29, $logMain['response_times']['123'][0]);
        $this->assertEquals(44, $logMain['response_times']['129'][0]);

        $this->assertEquals('123 P_USER_ID -- 410 TTA -- 13:54:13 MSG_TIME', $log[36]);




    }
}
