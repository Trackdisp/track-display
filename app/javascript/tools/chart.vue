<template>
  <highcharts :options="options"></highcharts>
</template>

<script>
import format from 'date-fns/format';

export default {
  props: {
    series: Array,
    groupBy: String,
  },
  data() {
    const that = this;

    return {
      options: {
        title: { text: '' },
        chart: { type: 'spline', zoomType: 'x' },
        xAxis: { type: 'datetime' },
        tooltip: {
          shared: true,
          useHTML: true,
          formatter() {
            let date;
            let startDate = new Date(this.x);
            switch (that.groupBy) {
              case "week":
                const endDate = new Date(startDate.getTime());
                endDate.setDate(endDate.getDate() + 6);
                date = format(startDate, "D [de] MMMM");
                date += ` al ${format(endDate, "D [de] MMMM")}`;
                break;
              case "day":
                date = format(startDate, "D [de] MMMM [de] YYYY");
                break;
              case "hour":
                date = format(startDate, "D [de] MMMM [de] YYYY, HH:mm");
                break;
            }
            let pointFormat = `${date}<br/>`

            this.points.forEach(point => {
              pointFormat += `<span style="color:${point.color}">\u25CF</span>
                ${point.series.name}: <b>${point.y}</b> <br/>`;

              if (point.female > 0 || point.male > 0) {
                pointFormat += `&emsp;\u25CF ${that.$i18n.t('chart.female')}: <b>${point.female}</b></span><br/>
                  &emsp;\u25CF ${that.$i18n.t('chart.male')}: <b>${point.male}</b><br/>
                  &emsp;\u25CF ${that.$i18n.t('chart.age')}: <b>${point.avg_age}</b><br/>`;
              }
            });

            return pointFormat;
          },
        },
        legend: false,
        credits: false,
        colors: ['#11b0fc', '#00c46c', '#fe7b4f'],
        series: this.series,
      },
    };
  },
};
</script>
