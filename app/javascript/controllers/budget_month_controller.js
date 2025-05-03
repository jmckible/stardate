import { Controller } from '@hotwired/stimulus'
import Highcharts from 'highcharts'

export default class extends Controller {

  static values = {
    balances: Array,
    built: { type: Boolean, default: false },
    categories: Array
  }

  balancesValueChanged() {
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
        type: 'column',
        height: 280,
        reflow: true
      },
      credits: {
        enabled: false
      },
      title:  { text: undefined },
      legend: { enabled: false },
      yAxis:  {
        title: false,
        labels: {
         formatter: function() {
           return '$' + this.value
         }
        }
      },
      xAxis: {
        categories: this.categoriesValue,
        labels: {
          style: {
            fontSize: '11px',
            overflow: 'justify'
          }
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
                rotation: -45,
                align: 'right'
              }
            }
          }
        }]
      },
      series: [{
        name: 'Month',
        data: this.balancesValue
      }]
    }
  }

}
