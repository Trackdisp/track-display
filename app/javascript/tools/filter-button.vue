<template>
  <div class="campaign-details__filter-buttons-container">
    <div class="campaign-details__filter-button" @click="cleanFilters">
      <img src="~/close.svg">
      Limpiar
    </div>
    <div class="campaign-details__filter-button" @click="applyFilters">
      <img src="~/check.svg">
      Aplicar
    </div>
  </div>
</template>

<script>

export default {
  computed: {
    filtersQueryString() {
      return this.$store.getters.filtersQueryString;
    },
  },
  methods: {
    applyFilters() {
      window.location.search = this.filtersQueryString;
    },
    cleanFilters() {
      this.$store.dispatch('cleanFilters');
    },
  },
};
</script>
