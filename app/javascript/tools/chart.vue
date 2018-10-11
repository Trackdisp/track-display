<template>
  <highcharts :options="options"></highcharts>
</template>

<script>
import format from 'date-fns/format';
import es from 'date-fns/locale/es';

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
            const ofTranslation = that.$i18n.t('conjunctions.of');
            const toTranslation = that.$i18n.t('conjunctions.to');
            const daysToNextWeek = 6;
            const startDate = new Date(this.x);
            let dateFormat;
            startDate.setMinutes(startDate.getMinutes() + startDate.getTimezoneOffset());

            function formatDate() {
              let date;

              function weekFormat() {
                const endDate = new Date(startDate.getTime());
                endDate.setDate(endDate.getDate() + daysToNextWeek);
                dateFormat = `D [${ofTranslation}] MMMM`;

                const formatedEndDate = format(endDate, dateFormat, { locale: es });

                date = format(startDate, dateFormat, { locale: es });
                date += ` ${toTranslation} ${formatedEndDate}`;
              }

              if (that.groupBy === 'week') {
                weekFormat();
              } else if (that.groupBy === 'day') {
                dateFormat = `D [${ofTranslation}] MMMM [${ofTranslation}] YYYY`;
                date = format(startDate, dateFormat, { locale: es });
              } else if (that.groupBy === 'hour') {
                dateFormat = `D [${ofTranslation}] MMMM [${ofTranslation}] YYYY, HH:mm`;
                date = format(startDate, dateFormat, { locale: es });
              }

              return date;
            }

            let pointFormat = `${formatDate()}<br/>`;

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
