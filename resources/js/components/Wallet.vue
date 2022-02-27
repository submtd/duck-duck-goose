<template>
    <div>
    </div>
</template>

<script>
    export default {
        data() {
            return {
                provider: null,
                web3: null
            }
        },
        methods: {
            setProvider(provider) {
                this.provider = provider;
            },
            provider() {
                return this.provider;
            },
            web3() {
                return this.web3;
            }
        }
    }
</script>
