<template>
  <v-btn-toggle v-model="groupBy">
    <v-btn flat value="week">
      {{ $t('groupDateSelector.week')}}
    </v-btn>
    <v-btn flat value="day">
      {{ $t('groupDateSelector.day')}}
    </v-btn>
    <v-btn flat value="hour">
      {{ $t('groupDateSelector.hour')}}
    </v-btn>
  </v-btn-toggle>
</template>

<script>
import { changeURLQueryParam } from '../helpers/url-helper';

export default {
  props: ['initialGroup'],
  data() {
    return {
      groupBy: this.initialGroup,
    };
  },
  watch: {
    groupBy(val) {
      if (val) {
        window.location.search = changeURLQueryParam('group_by', val);
      }
    },
  },
}
</script>
