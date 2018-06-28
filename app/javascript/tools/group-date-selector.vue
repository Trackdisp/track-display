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
  export default {
    props: ['initialGroup'],
    data() {
      return {
        groupBy: this.initialGroup,
      };
    },
    watch: {
      groupBy: function (val) {
        if (val) {
          const parser = document.createElement('a');
          parser.href = window.location.href;
          parser.search = `?group_by=${val}`;
          window.location.href = parser.href;
        }
      },
    },
  }
</script>
