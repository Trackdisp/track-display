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
        const storeSelectedIds = this.$store.getters.selectedFilterValues(this.queryParam);
        let filterVal;
        if (this.multiple) {
          filterVal = this.options.filter(opt => storeSelectedIds.includes(String(opt[this.trackBy])));
        } else {
          filterVal = this.options.find(opt => String(opt[this.trackBy]) === storeSelectedIds[0]);
        }

        return filterVal;
      },
      set(values) {
        let paramValue;
        if (this.multiple) {
          paramValue = values.map(val => val[this.trackBy]);
        } else {
          paramValue = values ? values[this.trackBy] : values;
        }
        this.$store.dispatch('changeFilter', { queryParam: this.queryParam, value: paramValue });
      },
    },
  },
};
</script>
