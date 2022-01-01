<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use App\Http\Controllers\Controller as Controller;

class LoginController extends Controller
{
    public function index()
    {
        return view('welcome');
    }

    public function login()
    {
        // We throw not found exception so legacy framework
        // Takes over this url `site_admin/user/login`
        throw new \Symfony\Component\HttpKernel\Exception\NotFoundHttpException();
    }

    public function logged()
    {
        return view('samples/logged',[
            'user' => \AppHelper::instance()->auth(),
            'items' => \erLhcoreClassModelChat::getList(['limit' => 1])
        ]);
    }

}