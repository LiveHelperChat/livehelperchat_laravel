<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;

/**
 * Base TestCase for tests that require legacy Live Helper Chat classes
 * 
 * This class handles the loading of legacy autoloader and classes from
 * the Live Helper Chat legacy codebase located in public/livehelperchat/lhc_web/
 */
abstract class LegacyTestCase extends TestCase
{
    /**
     * @var bool Track if legacy classes have been loaded
     */
    protected static $legacyLoaded = false;

    /**
     * @var string|null The original working directory before tests
     */
    protected static $originalWorkingDirectory = null;

    /**
     * @var string|null The legacy base path
     */
    protected static $legacyBasePath = null;

    /**
     * Set up the test case and load legacy classes
     */
    protected function setUp(): void
    {
        parent::setUp();
        
        // Load legacy classes once per test run
        if (!self::$legacyLoaded) {
            $this->loadLegacyClasses();
            self::$legacyLoaded = true;
            $db = \ezcDbInstance::get();
            $db->query("SET sql_mode='ONLY_FULL_GROUP_BY'");
        }

        // Change to legacy directory for each test
        if (self::$legacyBasePath && !self::$originalWorkingDirectory) {
            self::$originalWorkingDirectory = getcwd();
            chdir(self::$legacyBasePath);
        }
    }

    /**
     * Tear down the test case
     */
    protected function tearDown(): void
    {
        // Don't restore directory here - keep it for all tests
        parent::tearDown();
    }

    /**
     * Clean up after all tests in the class
     */
    public static function tearDownAfterClass(): void
    {
        // Restore original directory after all tests
        if (self::$originalWorkingDirectory) {
            chdir(self::$originalWorkingDirectory);
            self::$originalWorkingDirectory = null;
        }
        
        parent::tearDownAfterClass();
    }

    /**
     * Load the legacy Live Helper Chat autoloader and classes
     * 
     * @return void
     */
    protected function loadLegacyClasses(): void
    {
        // Check if already loaded
        if (class_exists('erLhcoreClassModelUserDep', false)) {
            return;
        }

        // Define the legacy base path using direct path construction
        // Go up from tests/Unit to the project root
        $legacyBasePath = realpath(__DIR__ . '/../../public');
        
        if (!$legacyBasePath) {
            $this->markTestSkipped(
                'Could not resolve public directory path'
            );
            return;
        }

        // Store the legacy base path for later use
        self::$legacyBasePath = $legacyBasePath;
        
        // Check if legacy code exists
        if (!file_exists($legacyBasePath . '/livehelperchat/lhc_web')) {
            $this->markTestSkipped(
                'Legacy Live Helper Chat code not found. ' .
                'Please initialize the livehelperchat submodule: ' .
                'git submodule update --init --recursive'
            );
            return;
        }

        // Change to legacy directory for autoloader
        chdir($legacyBasePath);

        try {
            // Define LHC_AUTOLOADED to prevent duplicate loading
            if (!defined('LHC_AUTOLOADED')) {
                define('LHC_AUTOLOADED', true);
            }

            // Load ezComponents base
            if (file_exists($legacyBasePath . '/ezcomponents/Base/src/base.php')) {
                require_once $legacyBasePath . '/ezcomponents/Base/src/base.php';

                // Add class repository
                \ezcBase::addClassRepository($legacyBasePath,'./lib/autoloads');
                
                // Register autoloaders
                spl_autoload_register(array('ezcBase','autoload'), true, false);
                spl_autoload_register(array('erLhcoreClassSystem','autoload'), true, false);
            }

            // Initialize the system
            if (class_exists('erLhcoreClassSystem')) {
                \erLhcoreClassSystem::init();
                
                // Set up database configuration callback
                \ezcBaseInit::setCallback(
                    'ezcInitDatabaseInstance',
                    'erLhcoreClassLazyDatabaseConfiguration'
                );
            }
        } catch (\Exception $e) {
            // Skip test on failure
            $this->markTestSkipped(
                'Failed to load legacy classes: ' . $e->getMessage()
            );
        }

        // Note: We stay in $legacyBasePath directory for tests to work correctly
    }

    /**
     * Check if a legacy class is available
     * 
     * @param string $className
     * @return bool
     */
    protected function isLegacyClassAvailable(string $className): bool
    {
        return class_exists($className, false);
    }

    /**
     * Create a mock for erLhcoreClassUser with common expectations
     * 
     * This method creates a reusable mock with default expectations for commonly
     * called methods. You can override or add more expectations in your tests.
     * 
     * @param int $userId The user ID to return (default: 1)
     * @param array $userData Additional user data (default: empty array)
     * @return \Mockery\MockInterface
     */
    protected function createMockUser(int $userId = 1, array $userData = []): \Mockery\MockInterface
    {
        $currentUser = \Mockery::mock('erLhcoreClassUser');
        
        // Set default behavior for commonly used methods
        $defaultUserData = \erLhcoreClassModelUser::fetch($userId);
        
        // Configure default expectations - allows() creates expectations that can be called 0+ times
        $currentUser->allows([
            'getUserID' => $userId,
            'getUserData' => $defaultUserData,
        ]);
        
        // Make it a passive mock to avoid "no expectations specified" errors
        $currentUser->shouldIgnoreMissing();
        
        return $currentUser;
    }
}
