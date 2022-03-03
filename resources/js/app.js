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

document.addEventListener('DOMContentLoaded', function () {
    window.addEventListener('scroll', function () {
        if(window.scrollY > 400) {
            this.document.getElementById('navbar').classList.add('fixed-top');
            navbar_height = document.querySelector('.navbar').offsetHeight;
            this.document.body.style.paddingTop = navbar_height + 'px';
        } else {
            this.document.getElementById('navbar').classList.remove('fixed-top');
            this.document.body.style.paddingTop = '0';
        }
    });
})
