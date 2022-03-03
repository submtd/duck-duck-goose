<?php

use Illuminate\Support\Facades\Route;

Route::get('/', static function () {
    return view('mint');
});

Route::get('getmatic', static function () {
    return view('getmatic');
});

Route::get('team', static function () {
    return view('team');
});

Route::get('discord', static function () {
    return response()->redirectTo('https://discord.gg/PN4KuTNRCv');
});
