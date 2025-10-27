<?php

namespace App\Http\Middleware;

use Closure;
use App\Helpers\AppHelper;
use Illuminate\Http\Request;
use Symfony\Component\HttpKernel\Exception\AccessDeniedHttpException;

class LiveHelperChat
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure(\Illuminate\Http\Request): (\Illuminate\Http\Response|\Illuminate\Http\RedirectResponse)  $next
     * @return \Illuminate\Http\Response|\Illuminate\Http\RedirectResponse
     */
    public function handle(Request $request, Closure $next)
    {
        if (!AppHelper::instance()->auth()->isLogged()) {
            return redirect()->route('lhc_admin.login');
        }

        if (AppHelper::instance()->accessible($request) !== true) {
            throw new AccessDeniedHttpException();
        }

        return $next($request);
    }
}
