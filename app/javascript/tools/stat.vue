<template>
  <div @click="toggleShowBreakdown" class="campaign-details__summary-stat campaign-detail-data" v-on-clickaway="hide">
    <div :class="statClass" v-if="!showBreakdown">
      <img class="campaign-detail-data__icon" :src="image">
      <div class="campaign-detail-data__data-container">
        <span :class="valueClass">{{ value }}</span>
        <span class="campaign-detail-data__label">{{ translation }}</span>
      </div>
    </div>
    <div class="campaign-detail-data campaign-detail-data__gender-breakdown" v-else>
      <img src="~/male.svg"> {{ maleValue }} <br>
      <img src="~/female.svg"> {{ femaleValue }}
    </div>
  </div>
</template>

<script>
import { mixin as clickaway } from 'vue-clickaway';

export default {
  props: ['element', 'image'],
  mixins: [clickaway],
  data() {
    const elementParsed = JSON.parse(this.element);
    const optionalValuesClass = elementParsed.class ? `campaign-detail-data__data--${elementParsed.class}` : '';
    const optionalDataClass = elementParsed.female_value !== undefined && elementParsed.male_value !== undefined ?
      'campaign-detail-data--clickable' :
      '';

    return {
      valueClass: `campaign-detail-data__data ${optionalValuesClass}`,
      statClass: `campaign-detail-data__icon-data-container ${optionalDataClass}`,
      value: elementParsed.value,
      maleValue: elementParsed.male_value,
      femaleValue: elementParsed.female_value,
      translation: this.$i18n.t(`messages.campaignDetails.stats.${elementParsed.translation}`),
      showBreakdown: false,
      isClickable: elementParsed.female_value !== undefined && elementParsed.male_value !== undefined,
    };
  },
  methods: {
    toggleShowBreakdown() {
      if (this.isClickable) {
        this.showBreakdown = !this.showBreakdown;
      }
    },
    hide() {
      this.showBreakdown = false;
    },
  },
};
</script>
