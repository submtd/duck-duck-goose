<template>
    <div class="mt-5">
        <div v-show="alert" class="mb-3">
            <div class="alert alert-danger">{{ alert }}</div>
        </div>
        <div v-show="txid" class="mb-3">
            <div class="alert alert-success">Success! Transaction Hash: {{ txid }}</div>
        </div>
        <div v-show="!connected">
            <h6>Connect Your Wallet</h6>
            <button @click="connectMetaMask" class="btn btn-lg btn-success col-12 mb-2">MetaMask</button>
            <button @click="connectCoinbase" class="btn btn-lg btn-success col-12 mb-2">Coinbase Wallet</button>
            <button @click="connectWalletConnect" class="btn btn-lg btn-success col-12 mb-2">WalletConnect</button>
        </div>
        <div v-show="connected">
            <label class="visually-hidden" for="quantity">Quantity</label>
            <div class="input-group">
                <input type="number" class="form-control col-2" id="quantity" min="1" v-model="quantity">
                <button class="btn btn-lg btn-success col-10" @click="mint" :disabled="mint_button_disabled">Mint ({{ totalCost }} ETH)</button>
            </div>
            <div class="carousel slide text-center text-secondary" data-bs-ride="carousel">
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <small>A <strong class="text-success">goose</strong> is found every <strong class="text-dark"><i>{{ goosePercentage }} mints</i></strong>!</small>
                    </div>
                    <div class="carousel-item">
                        <small>The current prize for finding a <strong class="text-success">goose</strong> is <strong class="text-dark"><i>{{ prizeBank }} ETH</i></strong>!</small>
                    </div>
                    <div class="carousel-item">
                        <small>The prize <strong class="text-dark"><i>increases with every mint</i></strong> until a <strong class="text-success">goose</strong> is found!</small>
                    </div>
                    <div class="carousel-item">
                        <small><strong class="text-dark"><i>{{ totalSupply }}</i></strong> <strong class="text-success">Duck, Duck, Goose NFTs</strong> have been minted so far!</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import WalletConnectProvider from "@walletconnect/web3-provider";
    import WalletLink from "walletlink";
    import Web3 from "web3";

    const networkId = 4;
    const networkName = 'Rinkeby Testnet';
    const infuraId = 'b8e7a65f07574f89a1424b075a31f605';
    const infuraUrl = 'https://rinkeby.infura.io/v3/b8e7a65f07574f89a1424b075a31f605';
    const contractAddress = '0x3D9f4aCb56334236d5da164aF8d352E34D494990';
    const contractAbi = '[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"approved","type":"address"},{"indexed":true,"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"operator","type":"address"},{"indexed":false,"internalType":"bool","name":"approved","type":"bool"}],"name":"ApprovalForAll","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"goose","type":"uint256"}],"name":"GooseFound","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":true,"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[{"internalType":"address","name":"_address","type":"address"}],"name":"addressToString","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"approve","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"contractURI","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"geese","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"getApproved","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"goosePercentage","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"goosePrizePercentage","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"operator","type":"address"}],"name":"isApprovedForAll","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"quantity","type":"uint256"}],"name":"mint","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"ownerOf","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"price","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"prizeBank","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"safeTransferFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"},{"internalType":"bytes","name":"_data","type":"bytes"}],"name":"safeTransferFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"operator","type":"address"},{"internalType":"bool","name":"approved","type":"bool"}],"name":"setApprovalForAll","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_percentage","type":"uint256"}],"name":"setGoosePercentage","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_percentage","type":"uint256"}],"name":"setGoosePrizePercentage","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_price","type":"uint256"}],"name":"setPrice","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes4","name":"interfaceId","type":"bytes4"}],"name":"supportsInterface","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"uint256","name":"index","type":"uint256"}],"name":"tokenOfOwnerByIndex","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_tokenId","type":"uint256"}],"name":"tokenURI","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"transferFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"}]';

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
                goosePercentage: null,
                prizeBank: null,
                totalSupply: null,
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
            connectMetaMask() {
                try {
                    if(typeof window.ethereum == 'undefined') {
                        window.location.href = 'https://metamask.app.link/dapp/duckduckgoosenft.eth.link';
                        return false;
                    }
                    this.provider = window.ethereum;
                } catch(error) {
                    this.alert = error.message;
                    return false;
                }
                this.connect();
            },
            connectCoinbase() {
                try {
                    const walletlink = new WalletLink({
                        appName: 'Duck, Duck, Goose!',
                        appLogoUrl: 'data:image/png;base64,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',
                    });
                    this.provider = walletlink.makeWeb3Provider(
                        infuraUrl,
                        networkId
                    );
                } catch(error) {
                    this.alert = error.message;
                    return false;
                }
                this.connect();
            },
            connectWalletConnect() {
                try {
                    this.provider = new WalletConnectProvider({
                        infuraId: infuraId,
                    });
                } catch(error) {
                    this.alert = error.message;
                    return false;
                }
            },
            async connect() {
                this.alert = 'Waiting on response form wallet';
                try {
                    await this.provider.enable();
                    this.web3 = new Web3(this.provider);
                    const connectedNetworkId = await this.web3.eth.net.getId();
                    if(connectedNetworkId != networkId) {
                        this.alert = 'Incorrect network. Please connect to the Ethereum ' + networkName;
                        return false;
                    }
                    const accounts = await this.web3.eth.getAccounts();
                    this.account = accounts[0];
                    this.contract = new this.web3.eth.Contract(JSON.parse(contractAbi), contractAddress);
                    this.price = await this.contract.methods.price().call();
                    this.goosePercentage = 10000 / await this.contract.methods.goosePercentage().call();
                    this.prizeBank = this.web3.utils.fromWei(await this.contract.methods.prizeBank().call(), 'ether');
                    this.totalSupply = await this.contract.methods.totalSupply().call();
                    this.alert = null;
                    this.connected = true;
                } catch(error) {
                    this.alert = error.message;
                    return false;
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
                    this.prizeBank = this.web3.utils.fromWei(await this.contract.methods.prizeBank().call(), 'ether');
                    this.totalSupply = await this.contract.methods.totalSupply().call();
                    this.alert = null;
                    this.mint_button_disabled = false;
                } catch(error) {
                    this.alert = error.message;
                    this.mint_button_disabled = false;
                    return false;
                }
            }
        }
    }
</script>
