<template>
    <div class="wallet_button ml-5">
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#wallet-modal">
            {{ button_text }}
        </button>
        <div class="modal fade" id="wallet-modal" tabindex="-1" aria-labelledby="wallet-modal-label" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-body">
                        <meta-mask/>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import MetaMask from './wallets/MetaMask.vue';
    export default {
        props: [
            'network_id',
        ],
        components: {
            'meta-mask': MetaMask
        },
        data() {
            return {}
        },
        computed: {
            button_text() {
                if(this.$store.state.connected) {
                    return 'Disconnect Your Wallet';
                }
                return 'Connect Your Wallet';
            }
        }
    }
</script>
