import { Controller } from '@hotwired/stimulus'
import Highcharts from 'highcharts'

export default class extends Controller {

  static values = {
    built: { type: Boolean, default: false },
    startDay: Number,
    startMonth: Number,
    startYear: Number,
    weights: Array,
    workout: Array,
  }

  workoutValueChanged() {
    this._buildChart()
  }

  weightsValueChanged() {
    this._buildChart()
  }

  builtValueChanged() {
    this._buildChart()
  }

  _buildChart() {
    if (!this.builtValue) {
      this.builtValue = true
      const chart = new Highcharts.Chart(this._chartConfig)
    }
  }

  get _chartConfig() {
    return {
      chart: {
        renderTo: this.element,
        height: 280,
        reflow: true
      },
      credits: {
        enabled: false
      },
      title: { text: undefined },
      legend: { enabled: false },
      yAxis: [
        {
          title: false
        },
        {
          title: false,
          opposite: true
        }
      ],
      xAxis: {
        type: 'datetime',
        tickInterval: 24 * 3600 * 1000,
        labels: {
          step: 7,
          formatter: function () {
            return (Highcharts.dateFormat('%b %e', this.value));
          }
        }
      },
      plotOptions: {
        spline: {
          marker: {
            enabled: false
          },
          shadow: false,
          lineWidth: 2
        },
        column: {
          stacking: 'normal',
          shadow: false,
          pointWidth: 10,
          pointPadding: 0
        }
      },
      responsive: {
        rules: [{
          condition: {
            maxWidth: 500
          },
          chartOptions: {
            xAxis: {
              labels: {
                step: 14
              }
            }
          }
        }]
      },
      series: [{
        type: 'column',
        name: 'Workout',
        data: this.workoutValue,
        pointInterval: 24 * 3600000,
        pointStart: Date.UTC(this.startYearValue, this.startMonthValue, this.startDayValue),
        yAxis: 0,
        color: '#F0F'
      }, {
        type: 'spline',
        name: 'Weight',
        data: this.weightsValue,
        pointInterval: 24 * 3600000,
        pointStart: Date.UTC(this.startYearValue, this.startMonthValue, this.startDayValue),
        yAxis: 1,
        lineWidth: 4
      }]
    }
  }

}
