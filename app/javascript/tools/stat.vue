<template>
  <div class="campaign-detail-data campaign-details__summary-stat">
    <div class="campaign-detail-data__icon">
      <img :src="icon">
    </div>
    <div class="campaign-detail-data__data-container">
      <span :class="statClass">{{ value }}</span>
      <span class="campaign-detail-data__label">{{ translation }}</span>
    </div>
  </div>
</template>

<script>
export default {
  props: ['element'],
  data() {
    const elementParsed = JSON.parse(this.element);
    const optionalClass = elementParsed.class ? `campaign-detail-data__data--${elementParsed.class}` : '';

    return {
      icon: `/assets/${elementParsed.icon}`,
      statClass: `campaign-detail-data__data ${optionalClass}`,
      value: elementParsed.value,
      translation: this.$i18n.t(`messages.campaignDetails.stats.${elementParsed.translation}`),
    };
  },
};
</script>
