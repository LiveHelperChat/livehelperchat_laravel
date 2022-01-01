<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\LoginController;

/*
|--------------------------------------------------------------------------
| Web Routes for admin interface. They can be accessed using /site_admin prefix
| At the moment `/site_admin/user/login` and `/site_admin/logged` routes available only.
| It also provides sample how to require already existing permission
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/user/login', [LoginController::class, 'login'])->name('lhc_admin.login');

Route::group(['middleware' => 'lhc'], function () {
    Route::group(['permission' => [
        'm' => 'lhfront', // Module
        'f' => 'default'  // Function
    ]], function () {
        Route::any('/logged', [LoginController::class, 'logged'])->name( 'lhc.logged');
    });
});
