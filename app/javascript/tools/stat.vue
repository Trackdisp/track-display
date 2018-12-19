<template>
  <div @click="toggleShowBreakdown"
       class="campaign-details__summary-stat campaign-detail-data"
       :class="{ 'campaign-detail-data--clickable': clickable, 'campaign-detail-data--breakdown': showBreakdown }"
       v-on-clickaway="hide">
    <template v-if="!showBreakdown">
      <img class="campaign-detail-data__icon" :src="image">
      <div class="campaign-detail-data__data-container">
        <span :class="valueClass">{{ value }}</span>
        <span class="campaign-detail-data__label">{{ translation }}</span>
      </div>
    </template>
    <template v-else>
      <div class="campaign-detail-data__gender-container">
        <img class="campaign-detail-data__gender-icon" src="~/male.svg">
        {{ maleValue }}
      </div>
      <div class="campaign-detail-data__gender-container">
        <img class="campaign-detail-data__gender-icon" src="~/female.svg">
        {{ femaleValue }}
      </div>
    </template>
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

    return {
      valueClass: `campaign-detail-data__data ${optionalValuesClass}`,
      clickable: elementParsed.female_value !== undefined && elementParsed.male_value !== undefined,
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
