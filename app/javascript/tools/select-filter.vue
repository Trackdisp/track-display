<template>
  <vue-multiselect @open="setOpen" @close="setClosed" :options="options" :multiple="multiple" :class="selectClass" :label="label" :track-by="trackBy" v-model="selectedFilterValues" :placeholder="placeholder" :show-labels="false">
    <template slot="caret" v-if="isSingleAndSelectedAndClosed">
      <div @mousedown.prevent.stop="clear" class="multiselect__clear">
        <img src="~/close-green.svg">
      </div>
    </template>
  </vue-multiselect>
</template>

<script>
import Multiselect from 'vue-multiselect';

export default {
  props: ['initialOptions', 'label', 'trackBy', 'placeholder', 'queryParam', 'multiple'],
  components: {
    'vue-multiselect': Multiselect,
  },
  beforeMount() {
    this.$store.dispatch('setFilterOptions', { queryParam: this.queryParam, value: this.initialOptions });
  },
  data() {
    return {
      open: false,
    };
  },
  methods: {
    clear() {
      this.selectedFilterValues = null;
    },
    setOpen() {
      this.open = true;
    },
    setClosed() {
      this.open = false;
    },
  },
  computed: {
    selectClass() {
      return {
        'multiselect--active-filter': this.multiple ? this.selectedFilterValues.length > 0 : typeof this.selectedFilterValues !== 'undefined',
      };
    },
    options() {
      return this.$store.state.filtersOptions[this.queryParam];
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
    isSingleAndSelectedAndClosed() {
      return !this.multiple && this.selectedFilterValues && !this.open;
    },
  },
};
</script>
