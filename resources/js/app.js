import { createApp } from "vue";
import Mint from "./components/Mint";

import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap";

import Analytics from 'analytics';
import googleTagManager from '@analytics/google-tag-manager';

window.analytics = Analytics({
    app: 'duckduckgoose.club',
    plugins:  [
        googleTagManager({
            containerId: 'GTM-PVG2FPX',
        }),
    ],
});

const app = createApp({});
app.component('mint', Mint);
app.mount('#app');
