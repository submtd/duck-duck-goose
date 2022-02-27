<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <meta name="csrf-token" content="{{ csrf_token() }}">
        <link href="{{ mix('css/app.css') }}" rel="stylesheet">
        <title>@yield('title')</title>
    </head>
    <body>
        <div id="app">
            <nav class="navbar navbar-dark bg-dark navbar-expand-lg">
                <div class="container">
                    <a href="/" class="navbar-brand">Furio</a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbar" aria-controls="navbar" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbar">
                        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                            <li class="nav-item">
                                <a class="nav-link" href="#">Furswap</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">Vault</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">Liquidity</a>
                            </li>
                        </ul>
                        <ul class="navbar-nav ml-auto">
                            <li class="nav-item">
                                <a class="nav-link" href="#">Whitepaper</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">Tutorial</a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbar-dropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    Lang
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="navbar-dropdown">
                                    <li><a class="dropdown-item" href="#">English</a></li>
                                </ul>
                            </li>
                            <li class="nav-item ml-5">
                                <connect/>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
            <div class="container mt-5">
                @yield('content')
            </div>
        </div>
        <script src="{{ mix('js/app.js') }}"></script>
    </body>
</html>
