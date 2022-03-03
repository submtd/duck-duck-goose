@extends('layout')
@section('title', 'Mint your Duck, Duck, Goose!')
@section('content')
    <div class="container mt-5 mb-5">
        <div class="text-center">
            <h1>DUCK, DUCK, GOOSE!</h1>
            <h1 class="text-light bg-danger h4 p-2">HATCH A GOOSE AND WIN A PRIZE!</h1>
        </div>
        <div style="max-width: 500px; margin: 0 auto;">
            <mint/>
        </div>
        <div class="row mt-5">
            <div class="col align-middle" style="height: 100%;">
                <img class="img-fluid" src="/images/img1.png" alt="">
            </div>
            <div class="col align-middle" style="height: 100%;">
                <h2 class="h4 text-primary">IT ALL BEGINS HERE...</h2>
                <p class="align-middle" style="height: 100%">We are all too familiar with the classic game of Duck, Duck, Goose! Playing it as a child, always hoping that you would finally be picked as the goose. Well today is the day that we all get that chance. We present to you: Duck, Duck, Goose! on the blockchain! Never before have you had this much fun with an NFT. Every goose is a winner!</p>
            </div>
        </div>
        <div class="row mt-5">
            <div class="col align-middle" style="height: 100%;">
                <p class="align-middle" style="height: 100%">All Duck, Duck, Goose! NFT mints start out life as an egg. When enough eggs are minted, they all hatch, revealing a bunch of ducks and one goose! The lucky parent of the goose gets rewarded with a special prize, and then the cycle starts all over again.</p>
            </div>
            <div class="col align-middle text-end" style="height: 100%;">
                <img class="img-fluid" src="/images/img2.png" alt="">
            </div>
        </div>
        <div class="row mt-5">
            <div class="col align-middle" style="height: 100%;">
                <img class="img-fluid" src="/images/img3.png" alt="">
            </div>
            <div class="col align-middle" style="height: 100%;">
                <p class="align-middle" style="height: 100%">These eggs, ducks, and geese exist entirely on the blockchain and have programmatically assigned attributes such as background, foreground, breed, and generation. While they're all pretty similar, each Duck, Duck, Goose! NFT is extremely rare!</p>
            </div>
        </div>
        <div class="row mt-5">
            <div class="col align-middle" style="height: 100%;">
                <p class="align-middle" style="height: 100%">With each hatching cycle, the number of mints needed to hatch the next set of eggs gets bigger and bigger while the prize awarded to the goose holder grows as well! In order to keep things fun in perpetuity, whenever the hatch cycle grows to a certain size, it resets back to the beginning and we can start all over again!</p>
            </div>
            <div class="col align-middle text-end" style="height: 100%;">
                <img class="img-fluid" src="/images/img4.gif" alt="">
            </div>
        </div>
        <h2 class="text-primary mt-5 text-center">DUCK, DUCK, GOOSE! IS AN INEXPENSIVE WAY TO HAVE SOME FUN ON THE BLOCKCHAIN!</h2>
        <div class="row mt-5">
            <div class="col align-middle" style="height: 100%;">
                <img class="img-fluid" src="/images/img5.png" alt="">
            </div>
            <div class="col align-middle" style="height: 100%;">
                <h2 class="h4 text-success">THE HATCHING CYCLE</h2>
                <p class="align-middle" style="height: 100%">The starting hatch cycle is set to 5. This means that 5 eggs need to be minted before they can hatch. After a hatch cycle completes, the cycle is incrementing by "1" (e.g. 5 turns into 6, 6 into 7, etc). In each hatch cycle, there will be only one goose. The lucky parent of that goose will receive 90% of the contract balance! As the hatch cycles get bigger, so do the rewards! Eventually, when the hatch cycle reaches the maximum of 500, it will reset back to 5 so the game can start all over again.</p>
            </div>
        </div>
        <div class="row mt-5">
            <div class="col align-middle" style="height: 100%;">
                <p class="align-middle" style="height: 100%">Gas prices are way too high! We've worked hard to optimize the Duck, Duck, Goose! smart contract to be as gas efficient as possible in order to keep those mint prices down. In addition, we've set the minting price to <strong>ONLY 1 MATIC</strong>!</p>
            </div>
            <div class="col align-middle text-end" style="height: 100%;">
                <img class="img-fluid" src="/images/img6.png" alt="">
            </div>
        </div>
    </div>
@endsection
