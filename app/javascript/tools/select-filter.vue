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
        const currentUrl = window.location.href;
        if (val) {
          window.location.href = changeURLQueryParam(currentUrl, this.queryParam, val.id);
        } else {
          window.location.href = removeURLQueryParam(currentUrl, this.queryParam);
        }
      },
    }
  }
</script>
