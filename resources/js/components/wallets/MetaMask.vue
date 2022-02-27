<template>
    <div>
        <button class="btn btn-lg btn-primary" @click="connect">Connect MetaMask</button>
        <button class="btn btn-lg btn-danger" @click="disconnect">Disconnect MetaMask</button>
    </div>
</template>

<script>
    export default {
        methods: {
            connect() {
                this.$store.dispatch('connect', window.ethereum);
            },
            disconnect() {
                this.$store.dispatch('disconnect');
            }
        }
    }
</script>
