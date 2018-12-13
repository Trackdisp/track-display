import axios from 'axios';

export default {
  getDependantFiltersOptions(params) {
    return axios.get(`/api/v1${window.location.pathname}/dependant_filters_options.json?${params}`)
      .then((response) => response.data);
  },
};
