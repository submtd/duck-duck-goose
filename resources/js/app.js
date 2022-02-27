// Axios
window.axios = require('axios');
window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
let token = document.head.querySelector('meta[name="csrf-token"]');
if(token) {
    window.axios.defaults.headers.common['X-CSRF-TOKEN'] = token.textContent;
}
// Bootstrap
import 'bootstrap';
// Vue
import { createApp } from 'vue';
// Vuex
import store from './store';
// Components
import Connect from './components/Connect';
// App
const app = createApp({});
app.use(store);
app.component('connect', Connect);
app.mount('#app');
