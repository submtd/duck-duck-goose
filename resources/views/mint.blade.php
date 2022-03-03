@extends('layout')
@section('title', 'Mint your Duck, Duck, Goose!')
@section('content')
    <div class="container" style="max-width: 500px;">
        <h1 class="card-title">Duck, Duck, Goose!</h1>
        <p class="card-text text-secondary">Play the classic game of Duck, Duck, Goose on the blockchain. Hatch a goose and win a prize!</p>
        <mint/>
    </div>
@endsection
