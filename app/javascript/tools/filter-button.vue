<template>
  <div>
    <div @click="applyFilters">Aplicar</div>
    <div @click="cleanFilters">Limpiar</div>
  </div>
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
    cleanFilters() {
      this.$store.dispatch('cleanFilters');
    },
  },
};
</script>
