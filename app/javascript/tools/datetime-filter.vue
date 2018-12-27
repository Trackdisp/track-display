<template>
  <div class="datetime-filter">
    <div :class="['datetime-filter__input-container', { 'datetime-filter__input-container--empty': isEmpty }]">
      <flat-pickr class="datetime-filter__input" v-model="selectedDate" :config="config" :placeholder="placeholder"></flat-pickr>
    </div>
    <div v-if="!isEmpty" class="datetime-filter__clear-btn" @click="clear">
      <img src="~/close-green.svg">
    </div>
  </div>
</template>

<script>
import flatPickr from 'vue-flatpickr-component';
import { Spanish } from 'flatpickr/dist/l10n/es.js';

export default {
  props: ['placeholder', 'queryParam'],
  data() {
    return {
      config: {
        enableTime: true,
        altInput: true,
        altFormat: 'j M Y, H:i',
        dateFormat: 'Y-m-dTH:i',
        firstDayOfWeek: 1,
        locale: Spanish,
      },
    };
  },
  components: {
    flatPickr,
  },
  computed: {
    selectedDate: {
      get() {
        return this.$store.state.selectedFilters[this.queryParam][0];
      },
      set(newDate) {
        this.$store.dispatch('changeFilter', { queryParam: this.queryParam, value: newDate ? [newDate] : [] });
      },
    },
    isEmpty() {
      return !this.selectedDate;
    },
  },
  methods: {
    clear() {
      this.selectedDate = null;
    },
  },
};
</script>
