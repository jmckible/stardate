import { Controller } from '@hotwired/stimulus'
import Highcharts from 'highcharts'

export default class extends Controller {

  static values = { balances: Array, categories: Array }

  connect() {
    const config = {
      chart: {
        renderTo: this.element,
        type: 'column',
        width: 800,
        height: 280
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
        categories: this.categoriesValue
      },
      series: [{
        name: 'Month',
        data: this.balancesValue
      }]
    }

    const budgetMonth = new Highcharts.Chart(config)

  }

}
