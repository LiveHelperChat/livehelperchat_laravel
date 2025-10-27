<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class LiveHelperChatServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register() {
        $this->app->singleton("LiveHelperChat",function($app) {
            // here are the contents of the legacy index.php:
            require_once __DIR__ . "../../../public/index_legacy.php";
            die();
        });
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        //
    }
}
