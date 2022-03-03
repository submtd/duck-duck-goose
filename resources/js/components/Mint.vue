<template>
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
</template>

<script>
    import Web3 from "web3";

    const networkId = 137;
    const networkName = 'Polygon Mainnet';
    const contractAddress = '0xdC96bD307bAf3418B3e5E0d16b03e4e2b4da0281';
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
                window.analytics.track('clickedConnectWalletButton');
                try {
                    if(typeof window.ethereum == 'undefined') {
                        window.location.href = 'https://metamask.app.link/dapp/duckduckgoose.club';
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
                    window.analytics.track('connectedWallet');
                } catch(error) {
                    window.analytics.track('connectWalletFailed', {
                        message: error.message,
                    });
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
                window.analytics.track('clickedMintButton');
                this.mint_button_disabled = true;
                this.txid = null;
                this.alert = 'Waiting on response from wallet';
                try {
                    const gasPrice = await this.web3.eth.getGasPrice();
                    //const estimatedGas = await this.contract.methods.mint(this.quantity).estimateGas({ value: this.price * this.quantity, from: this.account });
                    const result = await this.contract.methods.mint(this.quantity).send({ value: this.price * this.quantity, from: this.account, gasPrice: gasPrice });
                    this.txid = result.transactionHash;
                    window.analytics.track('purchase', {
                        item: this.quantity,
                        value: this.totalCost,
                    });
                    this.alert = null;
                    this.mint_button_disabled = false;
                    this.getData();
                } catch(error) {
                    window.analytics.track('mintFailed', {
                        message: error.message,
                    });
                    this.alert = error.message;
                    this.mint_button_disabled = false;
                    return false;
                }
            }
        }
    }
</script>
