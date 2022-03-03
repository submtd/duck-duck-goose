<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>@yield('title')</title>
    </head>
    <body>
        <div class="container-fluid" style="background: url('/images/banner.jpg'); background-size: cover; background-position: center; height: 400px;">
        </div>
        <div class="container mt-5" id="app">
            @yield('content')
        </div>
        <script src="{{ mix('js/app.js') }}"></script>
    </body>
</html>
