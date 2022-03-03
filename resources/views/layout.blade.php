<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link rel="stylesheet" href="{{ mix('css/app.css') }}">
        <title>@yield('title')</title>
    </head>
    <body>
        <div class="container-fluid header-container"></div>
        <nav class="navbar navbar-expand-lg navbar-dark bg-primary" id="navbar">
            <div class="container text-center">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbar" aria-controls="navbar" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse d-flex justify-content-center" id="navbar">
                    <ul class="navbar-nav mb-2 mb-lg-0 d-flex justify-content-center">
                        <li class="nav-item">
                            <a class="nav-link" href="/">Mint</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/team">Team</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/getmatic"><strong>How To Get Matic</strong></a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="https://polygonscan.com/address/0xdC96bD307bAf3418B3e5E0d16b03e4e2b4da0281" target="_new">Contract</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="https://opensea.io/collection/duck-duck-goose-nft" target="_new">OpenSea</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/discord" target="_new">Discord</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="https://twitter.com/GooseHatcher" target="_new">Twitter</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="https://github.com/submtd/duck-duck-goose" target="_new">Github</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
        <div class="container mt-5" id="app">
            @yield('content')
        </div>
        <script src="{{ mix('js/app.js') }}"></script>
    </body>
</html>
