<?php

namespace App\Http\Middleware;

use Closure;
use App\Services\PermissionService;
use Illuminate\Http\Request;
use Symfony\Component\HttpKernel\Exception\AccessDeniedHttpException;

class LiveHelperChat
{
    protected PermissionService $permissionService;

    public function __construct(PermissionService $permissionService)
    {
        $this->permissionService = $permissionService;
    }

    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure(\Illuminate\Http\Request): (\Illuminate\Http\Response|\Illuminate\Http\RedirectResponse)  $next
     * @return \Illuminate\Http\Response|\Illuminate\Http\RedirectResponse
     */
    public function handle(Request $request, Closure $next)
    {
        $user = $this->permissionService->auth();

        if (!$user->isLogged()) {
            return redirect()->route('lhc_admin.login');
        }

        if (!$this->permissionService->checkAccess($request)) {
            throw new AccessDeniedHttpException();
        }

        // Bind the authenticated user to the container for dependency injection
        app()->instance(\erLhcoreClassUser::class, $user);

        return $next($request);
    }
}
