<template>
  <div>
    <div class="filters-container__display-button" v-if='!showingFilters' @click="showingFilters = true">
      Filtros
    </div>
    <div class="filters-container__content" :class="{ 'filters-container__content--open': showingFilters }">
      <div class="filters-container__header-container">
        <h3 class="filters-container__title">{{ $t('messages.campaignDetails.filters.title') }}</h3>
        <img class="filters-container__close-button" src="~/close-grey.svg" @click="showingFilters = false">
      </div>
      <div class="filters-container__filters">
        <div class="filters-container__filter">
          <select-filter :initial-options="locations" label="name" track-by="id" query-param="locations[]" :placeholder="$t('messages.campaignDetails.filters.locations')" :multiple="true"></select-filter>
        </div>
        <div class="filters-container__filter">
          <select-filter :initial-options="brands" label="name" track-by="id" query-param="brands[]" :placeholder="$t('messages.campaignDetails.filters.brands')" :multiple="true"></select-filter>
        </div>
        <div class="filters-container__filter">
          <select-filter :initial-options="channels" label="name" track-by="id" query-param="channels[]" :placeholder="$t('messages.campaignDetails.filters.channels')" :multiple="true"></select-filter>
        </div>
        <div class="filters-container__filter-separator"></div>
        <div class="filters-container__filter">
          <select-filter :initial-options="communes" label="name" track-by="id" query-param="communes[]" :placeholder="$t('messages.campaignDetails.filters.communes')" :multiple="true"></select-filter>
        </div>
        <div class="filters-container__filter">
          <select-filter :initial-options="regions" label="name" track-by="id" query-param="regions[]" :placeholder="$t('messages.campaignDetails.filters.regions')" :multiple="true"></select-filter>
        </div>
        <div class="filters-container__filter-separator"></div>
        <div class="filters-container__filter">
          <datetime-picker query-param="after" :placeholder="$t('messages.campaignDetails.filters.afterDate')"></datetime-picker>
        </div>
        <div class="filters-container__filter">
          <datetime-picker query-param="before" :placeholder="$t('messages.campaignDetails.filters.beforeDate')"></datetime-picker>
        </div>
        <div class="filters-container__filter-separator"></div>
        <div class="filters-container__filter">
          <select-filter :initial-options="genders" label="name" track-by="id" query-param="gender" :placeholder="$t('messages.campaignDetails.filters.gender')"></select-filter>
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
