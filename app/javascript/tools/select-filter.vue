<template>
  <vue-multiselect :options="options" :multiple="multiple" :class="selectClass" :label="label" :track-by="trackBy" v-model="selectedFilterValues" :placeholder="placeholder" :show-labels="false"></vue-multiselect>
</template>

<script>
import Multiselect from 'vue-multiselect';

export default {
  props: ['options', 'label', 'trackBy', 'placeholder', 'queryParam', 'multiple'],
  components: {
    'vue-multiselect': Multiselect,
  },
  computed: {
    selectClass() {
      return {
        'multiselect--active-filter': this.multiple ? this.selectedFilterValues.length > 0 : typeof this.selectedFilterValues !== 'undefined',
      };
    },
    selectedFilterValues: {
      get() {
        const storeSelectedIds = this.$store.state.selectedFilters[this.queryParam];
        let filterVal;
        if (this.multiple) {
          filterVal = this.options.filter(opt => storeSelectedIds.includes(String(opt[this.trackBy])));
        } else {
          filterVal = this.options.find(opt => storeSelectedIds.includes(String(opt[this.trackBy])));
        }

        return filterVal;
      },
      set(values) {
        let paramValue;
        if (this.multiple) {
          paramValue = values.map(val => String(val[this.trackBy]));
        } else {
          paramValue = values ? [String(values[this.trackBy])] : [];
        }
        this.$store.dispatch('changeFilter', { queryParam: this.queryParam, value: paramValue });
      },
    },
  },
};
</script>
