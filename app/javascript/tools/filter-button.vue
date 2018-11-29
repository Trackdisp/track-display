<template>
  <div @click="applyFilters">Aplicar</div>
</template>

<script>

export default {
  computed: {
    filtersQueryParamsString() {
      return this.$store.state.filtersQueryParamsString;
    },
  },
  methods: {
    applyFilters() {
      window.location.search = this.filtersQueryParamsString;
    },
  },
};
</script>
