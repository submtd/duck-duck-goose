<template>
    <div class="card mt-5" style="border: none;">
        <img class="card-img-top" src="data:image/png;base64,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" alt="Duck, Duck, Goose!"/>
        <div class="card-body text-center">
            <h1 class="card-title">Duck, Duck, Goose!</h1>
            <p class="card-text text-secondary">Play the classic game of Duck, Duck, Goose on the blockchain. Hatch a goose and win a prize!</p>
            <div class="mt-5">
                <div v-show="alert" class="mb-3">
                    <div class="alert alert-danger">{{ alert }}</div>
                </div>
                <div v-show="txid" class="mb-3">
                    <div class="alert alert-success">Success! Transaction Hash: {{ txid }}</div>
                </div>
                <div v-show="!connected">
                    <button @click="connect" class="btn btn-lg btn-success col-12 mb-2">Connect Your Wallet</button>
                </div>
                <div v-show="connected">
                    <label class="visually-hidden" for="quantity">Quantity</label>
                    <div class="input-group">
                        <input type="number" class="form-control col-2" id="quantity" min="1" v-model="quantity">
                        <button class="btn btn-lg btn-success col-10" @click="mint" :disabled="mint_button_disabled">Mint ({{ totalCost }} MATIC)</button>
                    </div>
                    <div class="carousel slide text-center text-secondary" data-bs-ride="carousel">
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <small>The current prize for hatching a <strong class="text-success">goose</strong> is <strong class="text-dark"><i>{{ prizeBank }} MATIC</i></strong>!</small>
                            </div>
                            <div class="carousel-item">
                                <small>The prize <strong class="text-dark"><i>increases with every mint</i></strong> until the <strong class="text-success">eggs</strong> are hatched!</small>
                            </div>
                            <div class="carousel-item">
                                <small><strong class="text-dark"><i>{{ ducks }}</i></strong> <strong class="text-success">ducks</strong> have been hatched so far!</small>
                            </div>
                            <div class="carousel-item">
                                <small><strong class="text-dark"><i>{{ geese }}</i></strong> <strong class="text-success">geese</strong> have been hatched so far!</small>
                            </div>
                            <div class="carousel-item">
                                <small>only <strong class="text-dark"><i>{{ hatchCycle - eggs }}</i></strong> mints left before the next <strong class="text-success">hatch</strong>!</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import Web3 from "web3";

    const networkId = 137;
    const networkName = 'Polygon Mainnet';
    const infuraId = 'b8e7a65f07574f89a1424b075a31f605';
    const infuraUrl = 'https://polygon-mainnet.infura.io/v3/b8e7a65f07574f89a1424b075a31f605';
    const contractAddress = '0x046fd68baf799922ffbaa61a6dc4f46257159452';
    const contractAbi = '[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"approved","type":"address"},{"indexed":true,"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"operator","type":"address"},{"indexed":false,"internalType":"bool","name":"approved","type":"bool"}],"name":"ApprovalForAll","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"goose","type":"uint256"}],"name":"GooseHatched","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":true,"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"approve","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"contractURI","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"ducks","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"eggs","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"geese","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"getApproved","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"goosePrizePercentage","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"hatchCycle","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"operator","type":"address"}],"name":"isApprovedForAll","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"items","outputs":[{"internalType":"enum DuckDuckGoose.itemType","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"quantity","type":"uint256"}],"name":"mint","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"ownerOf","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"price","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"prizeBank","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"safeTransferFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"},{"internalType":"bytes","name":"_data","type":"bytes"}],"name":"safeTransferFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"operator","type":"address"},{"internalType":"bool","name":"approved","type":"bool"}],"name":"setApprovalForAll","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_percentage","type":"uint256"}],"name":"setGoosePrizePercentage","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_cycle","type":"uint256"}],"name":"setHatchCycle","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_price","type":"uint256"}],"name":"setPrice","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes4","name":"interfaceId","type":"bytes4"}],"name":"supportsInterface","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"uint256","name":"index","type":"uint256"}],"name":"tokenOfOwnerByIndex","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_tokenId","type":"uint256"}],"name":"tokenURI","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"transferFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"}]';

    export default {
        data() {
            return {
                connected: false,
                account: null,
                provider: null,
                web3: null,
                contract: null,
                alert: null,
                mint_button_disabled: false,
                quantity: 1,
                txid: null,
                price: null,
                eggs: null,
                ducks: null,
                geese: null,
                hatchCycle: null,
                prizeBank: null,
            }
        },
        computed: {
            priceInEth: function() {
                try {
                    const web3 = new Web3();
                    return web3.utils.fromWei(this.price, 'ether');
                } catch(error) {}
            },
            totalCost: function() {
                try {
                    return Math.round(this.quantity * this.priceInEth * 10000) / 10000;
                } catch(error) {}
            }
        },
        methods: {
            async connect() {
                this.alert = 'Waiting on response from wallet';
                try {
                    if(typeof window.ethereum == 'undefined') {
                        window.location.href = 'https://metamask.app.link/dapp/duckduckgoosenft.eth.link';
                        return false;
                    }
                    this.provider = window.ethereum;
                    await this.provider.enable();
                    this.web3 = new Web3(this.provider);
                    const connectedNetworkId = await this.web3.eth.net.getId();
                    if(connectedNetworkId != networkId) {
                        this.alert = 'Incorrect network. Please connect to the ' + networkName;
                        return false;
                    }
                    const accounts = await this.web3.eth.getAccounts();
                    this.account = accounts[0];
                    this.contract = new this.web3.eth.Contract(JSON.parse(contractAbi), contractAddress);
                    this.alert = null;
                    this.connected = true;
                    this.getData();
                } catch(error) {
                    this.alert = error.message;
                    return false;
                }
            },
            async getData() {
                try {
                    this.price = await this.contract.methods.price().call();
                    this.eggs = await this.contract.methods.eggs().call();
                    this.ducks = await this.contract.methods.ducks().call();
                    this.geese = await this.contract.methods.geese().call();
                    this.hatchCycle = await this.contract.methods.hatchCycle().call();
                    this.prizeBank = this.web3.utils.fromWei(await this.contract.methods.prizeBank().call(), 'ether');
                } catch(error) {
                    this.alert = error.message;
                }
            },
            async mint() {
                this.mint_button_disabled = true;
                this.txid = null;
                this.alert = 'Waiting on response from wallet';
                try {
                    const gas = await this.contract.methods.mint(this.quantity).estimateGas({ from: this.account, value: this.price * this.quantity });
                    const result = await this.contract.methods.mint(this.quantity).send({ value: this.price * this.quantity, from: this.account, gas: gas });
                    this.txid = result.transactionHash;
                    this.alert = null;
                    this.mint_button_disabled = false;
                    this.getData();
                } catch(error) {
                    this.alert = error.message;
                    this.mint_button_disabled = false;
                    return false;
                }
            }
        }
    }
</script>
