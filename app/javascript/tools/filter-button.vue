<template>
  <div class="filter-button__container">
    <div class="filter-button__button"
         :class="{'filter-button__button--disabled': selectedFiltersEmpty}"
         @click="cleanFilters">
      <img src="~/close-red.svg" v-if="!selectedFiltersEmpty">
      <img src="~/close-disabled.svg" v-else>
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
    finalQueryString() {
      return this.$store.getters.finalQueryString();
    },
    selectedFiltersChanged() {
      return this.$store.getters.selectedFiltersChanged;
    },
    selectedFiltersEmpty() {
      return this.$store.getters.selectedFiltersEmpty;
    },
  },
  methods: {
    applyFilters() {
      if (this.selectedFiltersChanged) {
        window.location.search = this.finalQueryString;
      }
    },
    cleanFilters() {
      if (!this.selectedFiltersEmpty) {
        this.$store.dispatch('cleanFilters');
      }
    },
  },
};
</script>
