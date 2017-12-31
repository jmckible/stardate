import Highcharts from 'highcharts';

Highcharts.setOptions({
  lang: {
    thousandsSep: ','
  }
});

$(document).on('turbolinks:load', () => {
  $('.js-chart-area').each(function() {
    const id = $(this).attr('id');

    new Highcharts.Chart(id, {
      chart: {
        type: 'area'
      },
      title:  { text: false },
      legend: { enabled: false },
      yAxis: {
        title: false,
        labels: {
          formatter() {
            return `$${this.value / 1000}k`;
          }
        }
      },
      xAxis: {
        type: 'datetime',
        tickInterval: 24 * 3600 * 1000,
        labels: {
          step: 7,
          formatter() {
            return Highcharts.dateFormat('%b %e', this.value);
          }
        }
      },
      plotOptions: {
        area: {
          marker: {
            enabled: false,
            states: {
              hover: {
                enabled: true
              }
            }
          }
        }
      },
      tooltip: {
        formatter() {
          return `${Highcharts.dateFormat('%B %e, %Y', this.x)}: <b>$${Highcharts.numberFormat(this.y, 0)}</b>`;
        }
      },
      series: $(`#${id}`).data('series')
    });
  });
});
