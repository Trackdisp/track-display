import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';
import { changeURLQueryParam, getURLQueryParams, getURLQueryParamValues } from '../helpers/url-helper';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    filtersQueryParamsString: getURLQueryParams(),
  },
  getters: {
    selectedFilterValues: (state) => function (queryParam) {
      return getURLQueryParamValues(state.filtersQueryParamsString, queryParam);
    },
  },
  mutations: {
    changeFilter(state, payload) {
      state.filtersQueryParamsString = changeURLQueryParam(state.filtersQueryParamsString, payload.queryParam, payload.value);
    },
    cleanFilters(state) {
      state.filtersQueryParamsString = '';
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
