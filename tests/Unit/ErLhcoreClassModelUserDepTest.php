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
class ErLhcoreClassModelUserDepTest extends LegacyTestCase
{
    protected function tearDown(): void
    {
        Mockery::close();
        parent::tearDown();
    }

    /**
     * Test that getOnlineOperators returns array of operators with list all permission
     */
    public function test_get_online_operators_with_list_all_permission()
    {
        // Mock the current user using the reusable method from LegacyTestCase
        $currentUser = $this->createMockUser();

        // Test parameters
        $canListOnlineUsersAll = true;
        $filter = [];
        $limit = 10;
        $onlineTimeout = 300;
        $options = ['dashboard' => true];

        // Call the actual method
        $result = \erLhcoreClassModelUserDep::getOnlineOperators(
            $currentUser,
            $canListOnlineUsersAll,
            $filter,
            $limit,
            $onlineTimeout,
            $options
        );

        // Verify result structure
        $this->assertIsArray($result);
    }


}
