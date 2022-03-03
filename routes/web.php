<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('mint');
});

Route::get('discord', function () {
    return response()->redirectTo('https://discord.gg/PN4KuTNRCv');
});
