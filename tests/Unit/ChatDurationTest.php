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

        $this->assertEquals('1 P_USER_ID -- 28 TTA -- 09:12:25 MSG_TIME', $log[13]);
        $this->assertEquals(38, $duration);
        $this->assertEquals($expectedLogMain, $logMain);
    }
}
