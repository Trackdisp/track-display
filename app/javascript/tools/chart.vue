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
      const outThis = this;
      return {
        options : {
          title: { text: '' },
          chart: { type: 'spline', zoomType: 'x' },
          xAxis: { type: 'datetime' },
          tooltip: {
            shared: true,
            useHTML: true,
            xDateFormat: this.date_format,
            pointFormatter: function() {
              let format = '<span style="color:' + this.color + '">\u25CF</span> '
                + this.series.name + ': <b>' + this.y + '</b> <br/>';

              if (this.female > 0 || this.male > 0) {
                format += '&emsp;\u25CF ' + outThis.$i18n.t('chart.female') + ': <b>' + this.female + '</b></span><br/>'
                  + '&emsp;\u25CF ' + outThis.$i18n.t('chart.male') + ': <b>' + this.male + '</b><br/>'
                  + '&emsp;\u25CF ' + outThis.$i18n.t('chart.age') + ': <b>' + this.avg_age + '</b><br/>';
              }
              return format;
            }
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
