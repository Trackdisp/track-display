<template>
  <v-btn-toggle v-model="groupBy">
    <v-btn flat value="week">
      {{ $t('groupDateSelector.week')}}
    </v-btn>
    <v-btn flat value="day" :disabled="shouldDisableDay">
      {{ $t('groupDateSelector.day')}}
    </v-btn>
    <v-btn flat value="hour" :disabled="shouldDisableHour">
      {{ $t('groupDateSelector.hour')}}
    </v-btn>
  </v-btn-toggle>
</template>

<script>
import { changeURLQueryParam } from '../helpers/url-helper';

export default {
  computed: {
    groupBy: {
      get() {
        return this.$store.state.groupBy;
      },
      set(val) {
        if (val) {
          window.location.search = changeURLQueryParam('group_by', val);
        }
      },
    },
    shouldDisableHour() {
      return this.$store.getters.shouldDisableHour;
    },
    shouldDisableDay() {
      return this.$store.getters.shouldDisableDay;
    },
  },
  watch: {
    shouldDisableDay(value) {
      if (value && ['day', 'hour'].includes(this.groupBy)) {
        this.groupBy = 'week';
      }
    },
    shouldDisableHour(value) {
      if (value && this.groupBy === 'hour') {
        this.groupBy = 'day';
      }
    },
  },
};
</script>
