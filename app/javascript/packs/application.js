/* eslint no-console:0 */
/* global document */

import Vue from 'vue/dist/vue.esm';
import Highcharts from 'highcharts';
import VueChartkick from 'vue-chartkick';
import VueI18n from 'vue-i18n';
import Vuetify from 'vuetify';

import GroupDateSelector from '../tools/group-date-selector.vue';
import SelectFilter from '../tools/select-filter.vue';
import Locales from '../locales/locales';

document.addEventListener('DOMContentLoaded', () => {
  Highcharts.setOptions({
    lang: Locales.messages[document.documentElement.lang].graphs,
  });
  Vue.use(VueChartkick, { adapter: Highcharts });
  Vue.use(VueI18n);
  Vue.use(Vuetify);

  if (document.getElementById('app') !== null) {
    new Vue({
      el: '#app',
      i18n: new VueI18n({
        locale: document.documentElement.lang,
        messages: Locales.messages,
      }),
      components: {
        'group-date-selector': GroupDateSelector,
        'select-filter': SelectFilter,
      },
    });
  }
});
