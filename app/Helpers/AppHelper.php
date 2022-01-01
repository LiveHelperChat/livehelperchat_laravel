<?php

namespace App\Helpers;

use Illuminate\Http\Request;

class AppHelper
{
    public static function instance()
    {
        return new AppHelper();
    }

    public function auth()
    {
        return \erLhcoreClassUser::instance();
    }

    public function accessible(Request $request)
    {
        
        $required = $request->route()->getAction();

        if (isset($required['permission']['m']) &&
            isset($required['permission']['f'])
        ) {
            return $this->auth()->hasAccessTo($required['permission']['m'],$required['permission']['f']);
        }

        return true;
    }
}