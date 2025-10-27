<?php

namespace App\Services;

use Illuminate\Http\Request;

class PermissionService
{
    /**
     * Check if the user has access to the requested route.
     */
    public function checkAccess(Request $request): bool
    {
        $required = $request->route()->getAction();

        if (isset($required['permission']['m'], $required['permission']['f'])) {
            return \erLhcoreClassUser::instance()
                ->hasAccessTo($required['permission']['m'], $required['permission']['f']);
        }

        return true;
    }

    /**
     * Get the authenticated user instance.
     */
    public function auth(): \erLhcoreClassUser
    {
        return \erLhcoreClassUser::instance();
    }
}
