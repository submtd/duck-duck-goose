import { createApp } from "vue";
import Mint from "./components/Mint";

import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap";

const app = createApp({});
app.component('mint', Mint);
app.mount('#app');
