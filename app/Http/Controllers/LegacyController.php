<?php

namespace App\Http\Controllers;

class LegacyController extends Controller
{
    public function index()
    {
        return view('welcome');
    }

    public function anonymous()
    {
        return view('samples/anonymous');
    }

}