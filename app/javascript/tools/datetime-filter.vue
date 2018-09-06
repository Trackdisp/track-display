<template>
  <flat-pickr class="flat-pick" v-model="auxDate" :config="config" :placeholder="placeholder" @on-close="modifyParamFilter"></flat-pickr>
</template>

<script>
import flatPickr from 'vue-flatpickr-component';
import { Spanish } from 'flatpickr/dist/l10n/es.js';
import { changeURLQueryParam, removeURLQueryParam } from '../helpers/url-helper';

export default {
  props: ['initialValue', 'placeholder', 'queryParam'],
  data() {
    return {
      date: this.initialValue,
      auxDate: this.initialValue,
      config: {
        enableTime: true,
        altInput: true,
        altFormat: 'j F Y, H:i',
        dateFormat: 'Y-m-dTH:i',
        firstDayOfWeek: 1,
        locale: Spanish,
      },
    };
  },
  components: {
    flatPickr,
  },
  methods: {
    modifyParamFilter(selectedDates, dateStr) {
      if (this.date !== dateStr) {
        if (dateStr) {
          window.location.search = changeURLQueryParam(this.queryParam, dateStr);
        } else {
          window.location.search = removeURLQueryParam(this.queryParam);
        }
      }
    },
  },
};
</script>
