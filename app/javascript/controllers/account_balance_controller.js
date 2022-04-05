import { Controller } from '@hotwired/stimulus'
import Highcharts from 'highcharts'

export default class extends Controller {

  static values = { balances: Array, categories: Array }

  connect() {
    const config = {
      chart: {
        renderTo: this.element,
        defaultSeriesType: 'spline',
        width: 800,
        height: 280
      },
      credits: {
        enabled: false
      },
      title:  { text: undefined },
      legend: { enabled: false },
      yAxis: {
        title: false,
        plotLines: [{
          color: '#000000',
          width: 2,
          value: 0
        }]
      },
      xAxis: {
        categories: this.categoriesValue,
        labels:{
          step: 12
        },
      },
      series: [{
        name: 'Balance',
        color: '#00CCFF',
        data: this.balancesValue
      }]
    }

    const balance = new Highcharts.Chart(config)

  }

}
