import { createStore, createLogger } from 'vuex';
import Web3 from 'web3';
const debug = process.env.NODE_ENV !== 'production';

export default createStore({
    strict: debug,
    plugins: debug ? [createLogger()] : [],
    state: {
        connected: false,
        provider: null,
        web3: null,
        networkId: null,
        account: null
    },
    mutations: {
        provider (state, provider) {
            state.provider = provider;
        },
        web3 (state, web3) {
            state.web3 = web3;
        },
        networkId (state, networkId) {
            state.networkId = networkId;
        },
        account (state, account) {
            state.account = account;
        },
        connected (state, connected) {
            state.connected = connected;
        }
    },
    actions: {
        async connect (context, provider) {
            context.commit('provider', provider);
            //try {
                await provider.enable();
                const web3 = new Web3(provider);
                const networkId = await web3.eth.net.getId();
                const accounts = await web3.eth.getAccounts();
                context.commit('provider', provider);
                context.commit('web3', web3);
                context.commit('networkId', networkId);
                context.commit('account', accounts[0]);
                context.commit('connected', true);
            //} catch (error) {
                //alert(error.message);
            //}
        },
        disconnect (context) {
            try {
                context.state.provider.close();
                context.state.provider.disconnect();
            } catch (error) {
                // do nothing
            }
            context.commit('provider', null);
            context.commit('web3', null);
            context.commit('networkId', null);
            context.commit('account', null);
            context.commit('connected', false);
        }
    }
});
