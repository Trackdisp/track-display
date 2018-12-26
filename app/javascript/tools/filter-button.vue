<template>
  <div class="filter-button__container">
    <div class="filter-button__button" @click="cleanFilters">
      <img src="~/close-red.svg">
      Limpiar
    </div>
    <div class="filter-button__button"
         :class="{'filter-button__button--disabled': !selectedFiltersChanged}"
         @click="applyFilters">
      <img src="~/check.svg" v-if="selectedFiltersChanged">
      <img src="~/check-disabled.svg" v-else>
      Aplicar
    </div>
  </div>
</template>

<script>

export default {
  computed: {
    filtersQueryString() {
      return this.$store.getters.filtersQueryString();
    },
    selectedFiltersChanged() {
      return this.$store.getters.selectedFiltersChanged;
    },
  },
  methods: {
    applyFilters() {
      if (this.selectedFiltersChanged) {
        window.location.search = this.filtersQueryString;
      }
    },
    cleanFilters() {
      this.$store.dispatch('cleanFilters');
    },
  },
};
</script>
