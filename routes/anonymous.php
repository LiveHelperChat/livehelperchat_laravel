<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\LegacyController;
/*
|--------------------------------------------------------------------------
| Web Routes without setting any cookie. Can be used for anonymous visitors
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "anonymous" middleware group. Now create something great!
|
*/
Route::any('/anonymous', [LegacyController::class, 'anonymous'])->name( 'lhc.anonymous');