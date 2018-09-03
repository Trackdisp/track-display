<template>
  <div @click="toggleShow" :class="clickableClass" v-on-clickaway="hide">
    <div class="campaign-detail-data ">
      <div class="campaign-detail-data__icon">
        <img :src="icon">
      </div>
      <div class="campaign-detail-data__data-container">
        <span :class="statClass">{{ value }}</span>
        <span class="campaign-detail-data__label">{{ translation }}</span>
      </div>
    </div>
    <div v-if="isClickable" v-show="show">Hombres: {{ maleValue }} <br>Mujeres: {{ femaleValue }}</div>
  </div>
</template>

<script>
import { mixin as clickaway } from 'vue-clickaway';

export default {
  props: ['element'],
  mixins: [clickaway],
  data() {
    const elementParsed = JSON.parse(this.element);
    const optionalClass = elementParsed.class ? `campaign-detail-data__data--${elementParsed.class}` : '';
    const clickable = elementParsed.female_value !== undefined && elementParsed.male_value !== undefined ?
      'campaign-details__summary-stat--clickable' :
      '';

    return {
      icon: `/assets/${elementParsed.icon}`,
      statClass: `campaign-detail-data__data ${optionalClass}`,
      clickableClass: `campaign-details__summary-stat ${clickable}`,
      value: elementParsed.value,
      maleValue: elementParsed.male_value,
      femaleValue: elementParsed.female_value,
      translation: this.$i18n.t(`messages.campaignDetails.stats.${elementParsed.translation}`),
      show: false,
      isClickable: elementParsed.female_value !== undefined && elementParsed.male_value !== undefined,
    };
  },
  methods: {
    toggleShow() {
      this.show = !this.show;
    },
    hide() {
      this.show = false;
    },
  },
};
</script>
