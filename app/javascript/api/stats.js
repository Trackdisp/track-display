import axios from 'axios';

export default {
  getStats(filteredCampaign) {
    return axios.get('/api/v1/campaigns/stats', {
      params: filteredCampaign,
    }).then((response) => response.data);
  },
};
