import Vue from 'vue';
import Vuex from 'vuex';
import { changeURLQueryParam, getURLQueryParams } from '../helpers/url-helper';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    filtersQueryParamsString: getURLQueryParams(),
  },
  mutations: {
    changeFilter(state, payload) {
      state.filtersQueryParamsString = changeURLQueryParam(state.filtersQueryParamsString, payload.queryParam, payload.value);
    },
  },
  actions: {
    changeFilter({ commit }, payload) {
      commit('changeFilter', payload);
    },
  },
});
