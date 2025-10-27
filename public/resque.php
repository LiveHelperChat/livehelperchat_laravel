<?php

/**
 * Global queue
 *
 * REDIS_BACKEND=localhost:6379 REDIS_BACKEND_DB=0 VERBOSE=1 COUNT=1 QUEUE='*' /usr/bin/php resque.php > var/resque.log
 *
 * by priority
 *
 * */

$QUEUE = getenv('QUEUE');

if(empty($QUEUE)) {
    die("Set QUEUE env var containing the list of queues to work.\n");
}

require __DIR__.'/../vendor/autoload.php';
require_once "ezcomponents/Base/src/base.php"; // dependent on installation method, see below

ezcBase::addClassRepository( './','./lib/autoloads');

spl_autoload_register(array('ezcBase','autoload'), true, false);
spl_autoload_register(array('erLhcoreClassSystem','autoload'), true, false);

// your code here
ezcBaseInit::setCallback(
    'ezcInitDatabaseInstance',
    'erLhcoreClassLazyDatabaseConfiguration'
);

function defaultCronjobFatalHandler($errno, $errstr, $errfile, $errline) {

    $msg = 'Unexpected error, the message was : ' . $errstr . ' in ' . $errfile . ' on line ' . $errline;

    $trace = debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS);

    if ($errno == E_USER_ERROR || $errno == E_COMPILE_ERROR || $errno == E_PARSE || $errno == E_ERROR || $errno == E_RECOVERABLE_ERROR || $errno == E_WARNING) {
        error_log($msg);

        erLhcoreClassLog::write($msg);

        $db = ezcDbInstance::get();
        $db->reconnect();

        erLhcoreClassLog::write(
            json_encode([
                'msg' => $msg,
                'trace' => $trace
            ]),
            ezcLog::SUCCESS_AUDIT,
            array(
                'source' => 'lhc',
                'category' => 'resque_fatal',
                'line' => __LINE__,
                'file' => __FILE__,
                'object_id' => 0
            )
        );
    }

    return false;
}

function defaultCronjobExceptionHandler($e) {

    error_log($e);

    erLhcoreClassLog::write(json_encode([
        'message' => $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine(),
        'trace' => $e->getTrace(),
        'raw' => (string)$e,
    ],JSON_PRETTY_PRINT));

    $db = ezcDbInstance::get();
    $db->reconnect();

    erLhcoreClassLog::write(
        json_encode([
            'message' => $e->getMessage(),
            'file' => $e->getFile(),
            'line' => $e->getLine(),
            'trace' => $e->getTrace(),
            'raw' => (string)$e,
        ],JSON_PRETTY_PRINT)
        ,
        ezcLog::SUCCESS_AUDIT,
        array(
            'source' => 'lhc',
            'category' => 'resque_exception',
            'line' => __LINE__,
            'file' => __FILE__,
            'object_id' => 0
        )
    );
}

function defaultShutdownHandler() {
    $error = error_get_last();

    if ($error && in_array($error['type'], [E_ERROR, E_CORE_ERROR, E_COMPILE_ERROR, E_PARSE])) {
        $errorData = [
            'job_id' => null,
            'job_class' => 'Fatal Error',
            'queue' => 'unknown',
            'error_message' => $error['message'],
            'error_trace' => "File: {$error['file']}, Line: {$error['line']}",
            'error_type' => 'Fatal Error',
            'created_at' => date('Y-m-d H:i:s'),
            'worker_id' => gethostname() . ':' . getmypid()
        ];

        error_log(json_encode($errorData,JSON_PRETTY_PRINT));

        $db = ezcDbInstance::get();
        $db->reconnect();

        erLhcoreClassLog::write(
            json_encode([
                'message' => $error['message'],
                'file' => $error['file'],
                'line' =>$error['line'],
            ],JSON_PRETTY_PRINT)
            ,
            ezcLog::SUCCESS_AUDIT,
            array(
                'source' => 'lhc',
                'category' => 'resque_fatal',
                'line' => __LINE__,
                'file' => __FILE__,
                'object_id' => 0
            )
        );
    }
}

function jobFailure($exception, $job){

    erLhcoreClassLog::write(json_encode([
        'message' => $exception->getMessage(),
        'file' => $exception->getFile(),
        'line' => $exception->getLine(),
        'trace' => $exception->getTrace(),
        'raw' => (string)$exception,
    ],JSON_PRETTY_PRINT));

    $db = ezcDbInstance::get();
    $db->reconnect();

    erLhcoreClassLog::write(
        json_encode([
            'message' => $exception->getMessage(),
            'file' => $exception->getFile(),
            'line' => $exception->getLine(),
            'trace' => $exception->getTrace(),
            'raw' => (string)$exception,
        ],JSON_PRETTY_PRINT)
        ,
        ezcLog::SUCCESS_AUDIT,
        array(
            'source' => 'lhc',
            'category' => 'resque_fatal',
            'line' => __LINE__,
            'file' => __FILE__,
            'object_id' => 0
        )
    );
}

set_exception_handler( 'defaultCronjobExceptionHandler' );
set_error_handler ( 'defaultCronjobFatalHandler' );
register_shutdown_function('defaultShutdownHandler');

// Register the job failure event listener
Resque_Event::listen('onFailure', 'jobFailure');

$instance = erLhcoreClassSystem::instance();
$instance->SiteDir = dirname(__FILE__).'/';
$instance->backgroundMode = true;

$cfgSite = erConfigClassLhConfig::getInstance();

$defaultSiteAccess = $cfgSite->getSetting( 'site', 'default_site_access' );
$optionsSiteAccess = $cfgSite->getSetting('site_access_options',$defaultSiteAccess);
$instance->Language = $optionsSiteAccess['locale'];
$instance->ThemeSite = $optionsSiteAccess['theme'];
$instance->SiteAccess = $defaultSiteAccess;
$instance->WWWDirLang = '';

erLhcoreClassModule::attatchExtensionListeners();

$tz = isset($optionsSiteAccess['time_zone']) ? $optionsSiteAccess['time_zone'] : $cfgSite->getSetting( 'site', 'time_zone' );

date_default_timezone_set($tz);

erLhcoreClassModule::$defaultTimeZone = $tz;
erLhcoreClassModule::$dateFormat = $cfgSite->getSetting('site', 'date_format', false);
erLhcoreClassModule::$dateHourFormat = $cfgSite->getSetting('site', 'date_hour_format', false);
erLhcoreClassModule::$dateDateHourFormat = $cfgSite->getSetting('site', 'date_date_hour_format', false);

//************************

if (!class_exists('Composer\Autoload\ClassLoader', false)) {
    die(
        'You need to set up the project dependencies using the following commands:' . PHP_EOL .
        'curl -s http://getcomposer.org/installer | php' . PHP_EOL .
        'php composer.phar install' . PHP_EOL
    );
}

$QUEUE = getenv('QUEUE');
if(empty($QUEUE)) {
    die("Set QUEUE env var containing the list of queues to work.\n");
}

/**
 * REDIS_BACKEND can have simple 'host:port' format or use a DSN-style format like this:
 * - redis://user:pass@host:port
 *
 * Note: the 'user' part of the DSN URI is required but is not used.
 */
$REDIS_BACKEND = getenv('REDIS_BACKEND');

// A redis database number
$REDIS_BACKEND_DB = getenv('REDIS_BACKEND_DB');
if(!empty($REDIS_BACKEND)) {
    if (empty($REDIS_BACKEND_DB))
        Resque::setBackend($REDIS_BACKEND);
    else
        Resque::setBackend($REDIS_BACKEND, $REDIS_BACKEND_DB);
}

Resque_Plugin::initialize();

$logLevel = false;
$LOGGING = getenv('LOGGING');
$VERBOSE = getenv('VERBOSE');
$VVERBOSE = getenv('VVERBOSE');
if(!empty($LOGGING) || !empty($VERBOSE)) {
    $logLevel = true;
}
else if(!empty($VVERBOSE)) {
    $logLevel = true;
}

$APP_INCLUDE = getenv('APP_INCLUDE');
if($APP_INCLUDE) {
    if(!file_exists($APP_INCLUDE)) {
        die('APP_INCLUDE ('.$APP_INCLUDE.") does not exist.\n");
    }

    require_once $APP_INCLUDE;
}

// See if the APP_INCLUDE containes a logger object,
// If none exists, fallback to internal logger
if (!isset($logger) || !is_object($logger)) {
    $logger = new Resque_Log($logLevel);
}

$BLOCKING = getenv('BLOCKING') !== FALSE;

$interval = 5;
$INTERVAL = getenv('INTERVAL');
if(!empty($INTERVAL)) {
    $interval = $INTERVAL;
}

$count = 1;
$COUNT = getenv('COUNT');
if(!empty($COUNT) && $COUNT > 1) {
    $count = $COUNT;
}

$PREFIX = getenv('PREFIX');
if(!empty($PREFIX)) {
    $logger->log(Psr\Log\LogLevel::INFO, 'Prefix set to {prefix}', array('prefix' => $PREFIX));
    Resque_Redis::prefix($PREFIX);
}

function cleanup_children($signal){
    $GLOBALS['send_signal'] = $signal;
}

if($count > 1) {
    $children = array();
    $GLOBALS['send_signal'] = FALSE;

    $die_signals = array(SIGTERM, SIGINT, SIGQUIT);
    $all_signals = array_merge($die_signals, array(SIGUSR1, SIGUSR2, SIGCONT, SIGPIPE));

    $logger->log(Psr\Log\LogLevel::DEBUG, 'Starting parent monitor {monitor}', array('monitor' => getmypid()));

    for($i = 0; $i < $count; ++$i) {
        $pid = Resque::fork();
        if($pid == -1) {
            $logger->log(Psr\Log\LogLevel::EMERGENCY, 'Could not fork worker {count}', array('count' => $i));
            die(1);
        }
        // Child, start the worker
        elseif(!$pid) {
            $queues = explode(',', $QUEUE);
            $worker = new Resque_Worker($queues);
            $worker->setLogger($logger);
            $worker->hasParent = TRUE;
            $logger->log(Psr\Log\LogLevel::NOTICE, 'Starting worker {worker}', array('worker' => $worker));
            $worker->work($interval, $BLOCKING);
            $logger->log(Psr\Log\LogLevel::NOTICE, 'Worker {worker} stopped', array('worker' => $worker));
            break;
        }
        else {
            $children[$pid] = 1;
            while (count($children) == $count){
                if (!isset($registered)) {
                    pcntl_async_signals(true);
                    foreach ($all_signals as $signal) {
                        pcntl_signal($signal,  "cleanup_children");
                    }

                    $PIDFILE = getenv('PIDFILE');
                    if ($PIDFILE) {
                        if(file_put_contents($PIDFILE, getmypid()) === false){
                            $logger->log(Psr\Log\LogLevel::NOTICE, 'Could not write PID information to {pidfile}', array('pidfile' => $PIDFILE));
                            die(2);
                        }
                    }

                    $registered = TRUE;
                }

                if(function_exists('setproctitle')) {
                    setproctitle('resque-' . Resque::VERSION . ": Monitoring {$count} children: [".implode(',', array_keys($children))."]");
                }

                $childPID = pcntl_waitpid(-1, $childStatus, WNOHANG);
                if ($childPID != 0) {
                    $logger->log(Psr\Log\LogLevel::NOTICE, 'A child worker died: {pid}', array('pid' => $childPID));
                    unset($children[$childPID]);
                    $i--;
                }
                usleep(250000);
                if ($GLOBALS['send_signal'] !== FALSE){
                    $killSignal = '';
                    if($GLOBALS['send_signal']) {
                        switch($GLOBALS['send_signal']) {
                            case 2:
                                $killSignal = 'SIGINT';
                                break;
                            case 3:
                                $killSignal = 'SIGQUIT';
                                break;
                            case 15:
                                $killSignal = 'SIGTERM';
                                break;
                        }
                    }

                    if($killSignal) {
                        $logger->log(Psr\Log\LogLevel::DEBUG, 'Received signal {signal} for monitor {monitor}', array(
                            'signal' => $killSignal,
                            'monitor' => getmypid()
                        ));
                    }

                    foreach ($children as $k => $v){
                        $logger->log(Psr\Log\LogLevel::DEBUG, 'Sending signal {signal} to pid {pid}', array(
                            'signal' => $killSignal,
                            'pid' => $k
                        ));
                        posix_kill($k, $GLOBALS['send_signal']);
                    }

                    $logger->log(Psr\Log\LogLevel::NOTICE, 'Propagated signal {signal} to children (kill = {kill})', array(
                        'signal' => $killSignal,
                        'kill' => in_array($GLOBALS['send_signal'], $die_signals) ? 'true' : 'false'
                    ));

                    if (in_array($GLOBALS['send_signal'], $die_signals)) {
                        foreach ($children as $k => $v){
                            $logger->log(Psr\Log\LogLevel::DEBUG, 'Waiting for {pid}', array(
                                'pid' => $k
                            ));
                            pcntl_waitpid($k, $childStatus);
                        }

                        $logger->log(Psr\Log\LogLevel::NOTICE, 'Finished shutting down all children', array('signal' => $killSignal));
                        if(!Resque::redis()->ping()) {
                            $logger->log(Psr\Log\LogLevel::EMERGENCY, 'Redis was already shut down!', array('signal' => $killSignal));
                        }
                        exit;
                    }
                    $GLOBALS['send_signal'] = FALSE;
                }
            }
        }
    }
}
// Start a single worker
else {
    $queues = explode(',', $QUEUE);
    $worker = new Resque_Worker($queues);
    $worker->setLogger($logger);
    $worker->hasParent = FALSE;

    $PIDFILE = getenv('PIDFILE');
    if ($PIDFILE) {
        if(file_put_contents($PIDFILE, getmypid()) === false) {
            $logger->log(Psr\Log\LogLevel::NOTICE, 'Could not write PID information to {pidfile}', array('pidfile' => $PIDFILE));
            die(2);
        }
    }

    $logger->log(Psr\Log\LogLevel::NOTICE, 'Starting worker {worker}', array('worker' => $worker));
    $worker->work($interval, $BLOCKING);
    $logger->log(Psr\Log\LogLevel::NOTICE, 'Worker {worker} stopped', array('worker' => $worker));
}
?>