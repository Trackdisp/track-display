<template>
  <vue-multiselect :options="options" :multiple="multiple" :class="selectClass" :label="label" :track-by="trackBy" v-model="filterValue" :placeholder="placeholder" :show-labels="false"></vue-multiselect>
</template>

<script>
import Multiselect from 'vue-multiselect';
import changeURLQueryParam from '../helpers/url-helper';

export default {
  props: ['options', 'label', 'initialSelected', 'trackBy', 'placeholder', 'queryParam', 'multiple'],
  data() {
    let filterVal;
    if (this.multiple) {
      const initialSelectedInOptions = this.initialSelected.filter(selected => this.options.map(val => val[this.trackBy]).includes(selected));
      if (this.initialSelected.length !== initialSelectedInOptions.length) {
        window.location.search = changeURLQueryParam(this.queryParam, initialSelectedInOptions);
      }
      filterVal = this.options.filter(opt => this.initialSelected.includes(opt[this.trackBy]));
    } else {
      filterVal = this.options.find(opt => String(opt[this.trackBy]) === this.initialSelected);
      if (this.initialSelected && filterVal === undefined) {
        window.location.search = changeURLQueryParam(this.queryParam, filterVal);
      }
    }

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
      let paramValue;
      if (this.multiple) {
        paramValue = values.map(val => val[this.trackBy]);
      } else {
        paramValue = values ? values[this.trackBy] : values;
      }
      window.location.search = changeURLQueryParam(this.queryParam, paramValue);
    },
  },
};
</script>
