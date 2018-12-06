import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';
import { getURLQueryParams } from '../helpers/url-helper';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    selectedFilters: {
      'locations[]': [],
      'brands[]': [],
      'channels[]': [],
      'communes[]': [],
      'regions[]': [],
      'gender': [],
      'after': [],
      'before': [],
      ...getURLQueryParams(),
    },
  },
  getters: {
    filtersQueryString(state) {
      let queryString = '';
      Object.entries(state.selectedFilters).forEach((pair) => {
        pair[1].forEach((value) => {
          queryString += `${pair[0]}=${value}&`;
        });
      });

      return queryString;
    },
  },
  mutations: {
    changeFilter(state, payload) {
      state.selectedFilters[payload.queryParam] = payload.value;
    },
    cleanFilters(state) {
      state.selectedFilters = {
        'locations[]': [],
        'brands[]': [],
        'channels[]': [],
        'communes[]': [],
        'regions[]': [],
        'gender': [],
        'after': [],
        'before': [],
      };
    },
  },
  actions: {
    changeFilter({ commit }, payload) {
      commit('changeFilter', payload);
    },
    cleanFilters({ commit }) {
      commit('cleanFilters');
    },
  },
});
