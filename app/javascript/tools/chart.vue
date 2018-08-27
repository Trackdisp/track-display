<template>
  <highcharts :options="options"></highcharts>
</template>

<script>
  import Chart from 'vue-highcharts';

  export default {
    props: {
      series: Array,
      date_format: String
    },
    data () {
      return {
        options : {
          title: { text: "" },
          chart: { type: 'spline', zoomType: 'x' },
          xAxis: { type: 'datetime' },
          tooltip: {
            shared: true,
            xDateFormat: this.date_format,
            pointFormat: '<span style="color:{point.color}">\u25CF</span> {series.name}: <b>{point.y}</b><br/>'
          },
          legend: false,
          credits: false,
          colors: ['#11b0fc', '#00c46c', '#fe7b4f'],
          series: this.series
        }
      }
    }
  }
</script>
