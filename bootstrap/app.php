<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Support\Facades\Route;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
        then: function () {
            // Admin routes with site_admin prefix and Admin namespace
            Route::middleware('web')
                ->namespace('App\Http\Controllers\Admin')
                ->prefix('site_admin')
                ->group(base_path('routes/admin.php'));

            // Anonymous routes without cookies
            Route::middleware('anonymous')
                ->namespace('App\Http\Controllers')
                ->group(base_path('routes/anonymous.php'));
        },
    )
    ->withMiddleware(function (Middleware $middleware) {
        // Global middleware - include Laravel defaults for secure request handling
        $middleware->use([
            \Illuminate\Http\Middleware\HandleCors::class,
            \App\Http\Middleware\TrustHosts::class,
            \App\Http\Middleware\TrustProxies::class,
            \App\Http\Middleware\PreventRequestsDuringMaintenance::class,
            \Illuminate\Foundation\Http\Middleware\ValidatePostSize::class,
            \App\Http\Middleware\TrimStrings::class,
            \Illuminate\Foundation\Http\Middleware\ConvertEmptyStringsToNull::class,
            \Illuminate\Foundation\Http\Middleware\HandlePrecognitiveRequests::class,
        ]);

        // Web middleware group
        $middleware->web(append: [
            \App\Http\Middleware\EncryptCookies::class,
            \Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse::class,
            \Illuminate\Session\Middleware\StartSession::class,
            \Illuminate\View\Middleware\ShareErrorsFromSession::class,
            \App\Http\Middleware\VerifyCsrfToken::class,
            \Illuminate\Routing\Middleware\SubstituteBindings::class,
        ]);

        // Anonymous middleware group
        $middleware->group('anonymous', [
            \Illuminate\Routing\Middleware\SubstituteBindings::class,
        ]);

        // API middleware group
        $middleware->api(
            prepend: ['throttle:api'],
            append: [
                \Illuminate\Routing\Middleware\SubstituteBindings::class,
            ],
        );

        // Route middleware aliases
        $middleware->alias([
            'auth' => \App\Http\Middleware\Authenticate::class,
            'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
            'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
            'can' => \Illuminate\Auth\Middleware\Authorize::class,
            'password.confirm' => \Illuminate\Auth\Middleware\RequirePassword::class,
            'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
            'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
            'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
            'lhc' => \App\Http\Middleware\LiveHelperChat::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions) {
        // Handle 404 and MethodNotAllowed exceptions by passing to legacy framework
        $exceptions->render(function (\Symfony\Component\HttpKernel\Exception\NotFoundHttpException $e, $request) {
            // Pass to legacy framework
            \App::make("LiveHelperChat");
            

            // Return a proper response instead of die()
            return response('', 200);
        });
        
        $exceptions->render(function (\Symfony\Component\HttpKernel\Exception\MethodNotAllowedHttpException $e, $request) {
            // Pass to legacy framework
            \App::make("LiveHelperChat");

            // Return a proper response instead of die()
            return response('', 200);
        });
        
        // Don't flash sensitive fields in validation exceptions
        $exceptions->dontFlash([
            'current_password',
            'password',
            'password_confirmation',
        ]);
    })->create();
