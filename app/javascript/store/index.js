import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';
import { getURLFilterParams, getURLQueryParam } from '../helpers/url-helper';

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
      ...getURLFilterParams(),
    },
    filtersOptions: {
      'locations[]': [],
      'brands[]': [],
      'channels[]': [],
      'communes[]': [],
      'regions[]': [],
      'gender': [],
    },
    groupBy: getURLQueryParam('group_by'),
  },
  getters: {
    filtersQueryString(state) {
      let queryString = state.groupBy ? `group_by=${state.groupBy}&` : '';
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
    setFilterOptions(state, payload) {
      state.filtersOptions[payload.queryParam] = payload.value;
    },
  },
  actions: {
    changeFilter({ commit }, payload) {
      commit('changeFilter', payload);
    },
    cleanFilters({ commit }) {
      commit('cleanFilters');
    },
    setFilterOptions({ commit }, payload) {
      commit('setFilterOptions', payload);
    },
  },
});
