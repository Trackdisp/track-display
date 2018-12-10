<template>
  <div>
    <div class="campaign-details__display_filters_button" v-if='!showingFilters' @click="showingFilters = true">
      Filtros
    </div>
    <div class="campaign-details__filters-container" :class="{ 'campaign-details__filters-container--open': showingFilters }">
      <div class="campaign-details__filters-header-container">
        <h3 class="campaign-details__title">{{ $t('messages.campaignDetails.filters.title') }}</h3>
        <img src="~/close.svg" @click="showingFilters = false">
      </div>
      <div class="campaign-details__filters">
        <div class="campaign-details__filter">
          <select-filter :options="locations" label="name" track-by="id" query-param="locations[]" :placeholder="$t('messages.campaignDetails.filters.locations')" :multiple="true"></select-filter>
        </div>
        <div class="campaign-details__filter">
          <select-filter :options="brands" label="name" track-by="id" query-param="brands[]" :placeholder="$t('messages.campaignDetails.filters.brands')" :multiple="true"></select-filter>
        </div>
        <div class="campaign-details__filter">
          <select-filter :options="channels" label="name" track-by="id" query-param="channels[]" :placeholder="$t('messages.campaignDetails.filters.channels')" :multiple="true"></select-filter>
        </div>
        <div class="campaign-details__filter-separator"></div>
        <div class="campaign-details__filter">
          <select-filter :options="communes" label="name" track-by="id" query-param="communes[]" :placeholder="$t('messages.campaignDetails.filters.communes')" :multiple="true"></select-filter>
        </div>
        <div class="campaign-details__filter">
          <select-filter :options="regions" label="name" track-by="id" query-param="regions[]" :placeholder="$t('messages.campaignDetails.filters.regions')" :multiple="true"></select-filter>
        </div>
        <div class="campaign-details__filter-separator"></div>
        <div class="campaign-details__filter">
          <datetime-picker query-param="after" :placeholder="$t('messages.campaignDetails.filters.afterDate')"></datetime-picker>
        </div>
        <div class="campaign-details__filter">
          <datetime-picker query-param="before" :placeholder="$t('messages.campaignDetails.filters.beforeDate')"></datetime-picker>
        </div>
        <div class="campaign-details__filter-separator"></div>
        <div class="campaign-details__filter">
          <select-filter :options="genders" label="name" track-by="id" query-param="gender" :placeholder="$t('messages.campaignDetails.filters.gender')"></select-filter>
        </div>
      </div>
      <filter-button></filter-button>
    </div>
  </div>
</template>

<script>
import SelectFilter from '../tools/select-filter.vue';
import DatetimePicker from '../tools/datetime-filter';
import FilterButton from '../tools/filter-button';

export default {
  props: ['locations', 'brands', 'channels', 'communes', 'regions', 'genders'],
  components: {
    SelectFilter,
    DatetimePicker,
    FilterButton,
  },
  data() {
    return {
      showingFilters: false,
    };
  },
};
</script>
