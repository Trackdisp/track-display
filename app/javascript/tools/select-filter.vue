<template>
  <vue-multiselect :options="options" :multiple="true" :class="selectClass" :label="label" :track-by="trackBy" v-model="filterValue" :placeholder="placeholder" :show-labels="false"></vue-multiselect>
</template>

<script>
import Multiselect from 'vue-multiselect';
import changeURLQueryParam from '../helpers/url-helper';

export default {
  props: ['options', 'label', 'initialSelected', 'trackBy', 'placeholder', 'queryParam'],
  data() {
    const initialSelectedInOptions = this.initialSelected.filter(selected => this.options.map(val => val[this.trackBy]).includes(selected));
    if (this.initialSelected.length !== initialSelectedInOptions.length) {
      window.location.search = changeURLQueryParam(this.queryParam, initialSelectedInOptions);
    }
    const filterVal = this.options.filter(opt => this.initialSelected.includes(opt[this.trackBy]));

    return {
      filterValue: filterVal,
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
    filterValue(values) {
      window.location.search = changeURLQueryParam(this.queryParam, values.map(val => val[this.trackBy]));
    },
  },
};
</script>
