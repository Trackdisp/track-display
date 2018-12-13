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

const HOUR_LIMIT = 4;
const DAY_LIMIT = 30;

export default {
  props: ['initialGroup'],
  data() {
    return {
      groupBy: this.initialGroup,
    };
  },
  computed: {
    chartDatesDiffInDays() {
      return this.$store.getters.chartDatesDiffInDays;
    },
    shouldDisableHour() {
      return this.chartDatesDiffInDays > HOUR_LIMIT;
    },
    shouldDisableDay() {
      return this.chartDatesDiffInDays > DAY_LIMIT;
    },
  },
  watch: {
    groupBy(val) {
      if (val) {
        window.location.search = changeURLQueryParam('group_by', val);
      }
    },
  },
};
</script>
