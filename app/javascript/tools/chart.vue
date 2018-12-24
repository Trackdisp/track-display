<template>
  <highcharts :options="options"></highcharts>
</template>

<script>
import format from 'date-fns/format';
import es from 'date-fns/locale/es';

export default {
  props: {
    series: Array,
    startDate: [String, Number],
    endDate: [String, Number],
  },
  mounted() {
    this.$store.dispatch('setInitialDateRange');
  },
  computed: {
    groupBy() {
      return this.$store.state.groupBy;
    },
    minRange() {
      // eslint-disable-next-line no-magic-numbers
      return ['day', 'week'].includes(this.groupBy) ? 1000 * 3600 * 24 * 3 : undefined;
    },
    tooltipOptions() {
      const that = this;

      return {
        shared: true,
        useHTML: true,
        formatter() {
          const ofTranslation = that.$i18n.t('conjunctions.of');
          const toTranslation = that.$i18n.t('conjunctions.to');
          const daysToNextWeek = 6;
          const startDate = new Date(this.x);
          let dateFormat;

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

          this.points.forEach(pointExtended => {
            pointFormat += `<span style="color:${pointExtended.color}">\u25CF</span>
              ${pointExtended.series.name}: <b>${pointExtended.y}</b> <br/>`;

            if (pointExtended.point.options.female > 0 || pointExtended.point.options.male > 0) {
              pointFormat += `&emsp;\u25CF ${that.$i18n.t('graphs.female')}: <b>${pointExtended.point.options.female}</b></span><br/>
                &emsp;\u25CF ${that.$i18n.t('graphs.male')}: <b>${pointExtended.point.options.male}</b><br/>
                &emsp;\u25CF ${that.$i18n.t('graphs.age')}: <b>${pointExtended.point.options.avg_age}</b><br/>`;
            }
          });

          return pointFormat;
        },
      };
    },
    options() {
      const that = this;
      const unitsColor = '#fe7b4f';

      return {
        title: { text: '' },
        chart: {
          type: 'spline',
          zoomType: 'x',
          events: {
            render() {
              const datetimeFormat = 'YYYY-MM-DDTHH:mm';
              const min = format(new Date(this.xAxis[0].min), datetimeFormat, { locale: es });
              const max = format(new Date(this.xAxis[0].max), datetimeFormat, { locale: es });
              that.$store.dispatch('setDateRange', { start: min, end: max });
            },
          },
        },
        xAxis: {
          type: 'datetime',
          minRange: that.minRange,
        },
        yAxis: [
          { title: { text: this.$i18n.t('graphs.peopleTitle') } },
          {
            title: {
              text: this.$i18n.t('graphs.unitsTitle'),
              style: { color: unitsColor },
            },
            opposite: true,
          },
        ],
        tooltip: this.tooltipOptions,
        legend: false,
        credits: false,
        colors: ['#11b0fc', '#00c46c', unitsColor],
        time: {
          useUTC: false,
        },
        plotOptions: {
          series: {
            turboThreshold: 0,
          },
        },
        series: this.series,
      };
    },
  },
};
</script>
