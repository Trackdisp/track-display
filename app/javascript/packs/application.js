/* eslint no-console:0 */
/* global document */

import Vue from 'vue/dist/vue.esm';
import Highcharts from 'highcharts';
import VueI18n from 'vue-i18n';
import Vuetify from 'vuetify';
import VueHighcharts from 'vue-highcharts';
import GroupDateSelector from '../tools/group-date-selector.vue';
import Stat from '../tools/stat';
import Sidebar from '../tools/sidebar';
import Chart from '../tools/chart.vue';
import Locales from '../locales/locales';
import store from '../store';

document.addEventListener('DOMContentLoaded', () => {
  Highcharts.setOptions({
    lang: Locales.messages[document.documentElement.lang].graphs,
  });
  Vue.use(VueI18n);
  Vue.use(Vuetify);
  Vue.use(VueHighcharts, { Highcharts });

  if (document.getElementById('app') !== null) {
    new Vue({ // eslint-disable-line no-new
      el: '#app',
      i18n: new VueI18n({
        locale: document.documentElement.lang,
        messages: Locales.messages,
      }),
      store,
      components: {
        GroupDateSelector,
        Chart,
        Stat,
        Sidebar,
      },
    });
  }
});
