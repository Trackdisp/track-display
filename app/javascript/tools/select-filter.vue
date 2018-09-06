<template>
  <vue-multiselect :options="options" :class="selectClass" :label="label" :track-by="trackBy" v-model="filterValue" :placeholder="placeholder" :show-labels="false"></vue-multiselect>
</template>

<script>
import Multiselect from 'vue-multiselect';
import { changeURLQueryParam, removeURLQueryParam } from '../helpers/url-helper';

export default {
  props: ['options', 'label', 'initialSelected', 'trackBy', 'placeholder', 'queryParam'],
  data() {
    return {
      filterValue: this.options.find(opt => opt[this.trackBy] === this.initialSelected),
    };
  },
  components: {
    'vue-multiselect': Multiselect,
  },
  computed: {
    selectClass() {
      return {
        'multiselect--active-filter': typeof this.filterValue !== 'undefined',
      };
    },
  },
  watch: {
    filterValue(val) {
      if (val) {
        window.location.search = changeURLQueryParam(this.queryParam, val.id);
      } else {
        window.location.search = removeURLQueryParam(this.queryParam);
      }
    },
  },
};
</script>
