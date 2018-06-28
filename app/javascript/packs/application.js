/* eslint no-console:0 */
/* global document */

import Vue from 'vue/dist/vue.esm';
import Highcharts from 'highcharts'
import Locales from '../locales/locales';
import VueChartkick from 'vue-chartkick'
import VueI18n from 'vue-i18n';

document.addEventListener('DOMContentLoaded', () => {
  Vue.use(VueChartkick, {adapter: Highcharts})
  Vue.use(VueI18n);

  if (document.getElementById('app') !== null) {
    new Vue({
      el: '#app',
      i18n: new VueI18n({
        locale: document.documentElement.lang,
        messages: Locales.messages,
      })
    });
  }
});
