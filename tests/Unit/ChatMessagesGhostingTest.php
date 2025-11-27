<?php

namespace Tests\Unit;

use Mockery;

/**
 * Unit tests for ChatMessagesGhosting::maskMessage method
 * 
 * This test class validates the behavior of the maskMessage method
 * which masks sensitive information in messages based on department-specific rules.
 * 
 * Note: This extends LegacyTestCase which handles loading the legacy Live Helper Chat code.
 */
class ChatMessagesGhostingTest extends LegacyTestCase
{
    protected function tearDown(): void
    {
        Mockery::close();
        parent::tearDown();
    }

    /**
     * Test that maskMessage properly masks sensitive data in a message
     */
    public function test_mask_message_with_sensitive_data()
    {
        // Test message containing various sensitive data patterns
        $message = 'asdfasdf sadfsda example@gmail.com sk-4d65a4sd65asd asdasdasd https://example.com https://google.com http://example.lt ftp://adsasd:dasd@example.com 1234123412341234 asdasd';

        // Mask parameters with department id 1 and REST API message type
        $maskParams = [
            'dep_id' => 1,
            'type' => \LiveHelperChat\Models\LHCAbstract\ChatMessagesGhosting::MSG_TYPE_REST
        ];

        // Call the actual method
        $result = \LiveHelperChat\Models\LHCAbstract\ChatMessagesGhosting::maskMessage(
            $message,
            $maskParams
        );

        // TODO: Add your assertions here for what you expect to get
        // For example:
        $this->assertStringNotContainsString('example@gmail.com', $result);
        $this->assertStringNotContainsString('1234123412341234', $result);
        
        // For now, verify result is a string
        $this->assertIsString($result);

        $this->assertEquals('asdfasdf sadfsda [mask]EMAIL_ADDRESS[/mask] [mask]SECRET_KEY[/mask] asdasdasd https://example.com [mask]URL_NOT_IN_ALLOW_LIST[/mask] [mask]URL_BLOCKED_SCHEME[/mask] [mask]URL_BLOCKED_SCHEME[/mask] [mask]CREDIT_CARD[/mask] asdasd',$result);
    }

    /**
     * Test maskMessage with return_array option
     */
    public function test_mask_message_returns_array_when_requested()
    {

        $message = 'asdfasdf sadfsda example@gmail.com sk-4d65a4sd65asd asdasdasd https://example.com https://google.com http://example.com ftp://adsasd:dasd@example.com 1234123412341234 asdasd';

        $maskParams = [
            'dep_id' => 1,
            'type' => \LiveHelperChat\Models\LHCAbstract\ChatMessagesGhosting::MSG_TYPE_REST,
            'return_array' => true
        ];

        $result = \LiveHelperChat\Models\LHCAbstract\ChatMessagesGhosting::maskMessage(
            $message,
            $maskParams
        );

        // Verify result structure when return_array is true
        $this->assertIsArray($result);
        $this->assertArrayHasKey('message', $result);
        $this->assertArrayHasKey('warning', $result);
    }
}
