<template>
  <div class="campaign-details__summary-stat" v-on-clickaway="hide">
    <div class="campaign-detail-data">
      <div @click="toggleShow" :class="statClass">
        <div class="campaign-detail-data__icon">
          <img :src="icon">
        </div>
        <div class="campaign-detail-data__data-container">
          <span :class="valueClass">{{ value }}</span>
          <span class="campaign-detail-data__label">{{ translation }}</span>
        </div>
      </div>
      <div class="campaign-detail-data campaign-detail-data__gender-breakdown" v-if="isClickable" v-show="show">
        Hombres: {{ maleValue }} <br>Mujeres: {{ femaleValue }}
      </div>
    </div>
  </div>
</template>

<script>
import { mixin as clickaway } from 'vue-clickaway';

export default {
  props: ['element'],
  mixins: [clickaway],
  data() {
    const elementParsed = JSON.parse(this.element);
    const optionalValuesClass = elementParsed.class ? `campaign-detail-data__data--${elementParsed.class}` : '';
    const optionalDataClass = elementParsed.female_value !== undefined && elementParsed.male_value !== undefined ?
      'campaign-detail-data--clickable' :
      '';

    return {
      icon: `/assets/${elementParsed.icon}`,
      valueClass: `campaign-detail-data__data ${optionalValuesClass}`,
      statClass: `campaign-detail-data__icon-data-container ${optionalDataClass}`,
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
