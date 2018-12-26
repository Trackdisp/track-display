import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';
import differenceInDays from 'date-fns/difference_in_days';
import { getURLFilterParams, getURLQueryParam } from '../helpers/url-helper';
import api from './api';

Vue.use(Vuex);

const HOUR_LIMIT = 4;
const DAY_LIMIT = 30;

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
    chartStartDate: null,
    chartEndDate: null,
    chartInitialStartDate: null,
    chartInitialEndDate: null,
    groupBy: getURLQueryParam('group_by') || 'day',
  },
  getters: {
    filtersQueryString: (state) => (groupBy) => {
      let queryString = groupBy || state.groupBy ? `group_by=${groupBy || state.groupBy}&` : '';
      const selectedFiltersCopy = { ...state.selectedFilters };

      if (state.chartInitialStartDate !== state.chartStartDate) {
        selectedFiltersCopy.after = [state.chartStartDate];
      }

      if (state.chartInitialEndDate !== state.chartEndDate) {
        selectedFiltersCopy.before = [state.chartEndDate];
      }

      Object.entries(selectedFiltersCopy).forEach((pair) => {
        pair[1].forEach((value) => {
          queryString += `${pair[0]}=${value}&`;
        });
      });

      return queryString.substring(0, queryString.length - 1);
    },
    shouldDisableHour(state) {
      const start = state.chartStartDate;
      const end = state.chartEndDate;

      return differenceInDays(new Date(end), new Date(start)) > HOUR_LIMIT;
    },
    shouldDisableDay(state) {
      const start = state.chartStartDate;
      const end = state.chartEndDate;

      return differenceInDays(new Date(end), new Date(start)) > DAY_LIMIT;
    },
  },
  mutations: {
    changeFilter(state, payload) {
      state.selectedFilters[payload.queryParam] = payload.value.sort();
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
    setDateRange(state, payload) {
      state.chartStartDate = payload.start;
      state.chartEndDate = payload.end;
    },
    setInitialDateRange(state) {
      state.chartInitialStartDate = state.chartStartDate;
      state.chartInitialEndDate = state.chartEndDate;
    },
  },
  actions: {
    changeFilter(context, payload) {
      context.commit('changeFilter', payload);
      api.getDependantFiltersOptions(context.getters.filtersQueryString)
        .then((filtersOptions) => {
          Object.entries(filtersOptions).forEach((pair) => {
            context.commit('setFilterOptions', { queryParam: pair[0], value: pair[1] });
          });
        });
    },
    cleanFilters({ commit }) {
      commit('cleanFilters');
    },
    setFilterOptions({ commit }, payload) {
      commit('setFilterOptions', payload);
    },
    setDateRange({ commit }, payload) {
      commit('setDateRange', payload);
    },
    setInitialDateRange({ commit }) {
      commit('setInitialDateRange');
    },
  },
});
