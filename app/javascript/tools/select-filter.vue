<template>
  <vue-multiselect :options="options" :label="label" :track-by="trackBy" v-model="filterValue" :placeholder="placeholder"></vue-multiselect>
</template>

<script>
  import Multiselect from 'vue-multiselect';
  import { changeURLQueryParam, removeURLQueryParam } from "../helpers/url-helper";


  export default {
    props: ['options', 'label', 'initialSelected', 'trackBy', 'placeholder', 'queryParam'],
    data() {
      return {
        filterValue: this.options.find(opt => opt[this.trackBy] === this.initialSelected)
      };
    },
    components: {
      'vue-multiselect': Multiselect,
    },
    watch: {
      filterValue: function (val) {
        if (val) {
          window.location.search = changeURLQueryParam(this.queryParam, val.id);
        } else {
          window.location.search = removeURLQueryParam(this.queryParam);
        }
      },
    }
  }
</script>
