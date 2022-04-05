import { Controller } from '@hotwired/stimulus'
import Highcharts from 'highcharts'

export default class extends Controller {

  static values = { expense: Array, income: Array, startDay: Number, startMonth: Number, startYear: Number }

  connect() {
    const expenseSum = this.expenseValue.reduce((sum, e) => sum + e, 0)
    const incomeSum = this.incomeValue.reduce((sum, e) => sum + e, 0)

    const series = [{
       name: 'Income',
       data: this.incomeValue,
       pointInterval: 24 * 3600 * 1000,
       pointStart: Date.UTC(this.startYearValue, this.startMonthValue, this.startDayValue),
       color: '#00CCFF'
    }]

    const expense = {
       name: 'Expense',
       data: this.expenseValue,
       pointInterval: 24 * 3600 * 1000,
       pointStart: Date.UTC(this.startYearValue, this.startMonthValue, this.startDayValue),
       color: '#FF00CC'
     }

    if (expenseSum < incomeSum) {
      series.push(expense)
    } else {
      series.unshift(expense)
    }

    const config = {
      chart: {
        renderTo: this.element,
        defaultSeriesType: 'area',
        width: 400,
        height: 280
      },
      credits: {
        enabled: false
      },
      title:  { text: undefined },
      legend: { enabled: false },
      yAxis: {
        title: false,
        labels: {
          formatter: function(){
            return('$' + this.value / 1000 + 'k');
          }
        }
      },
      xAxis: {
        type: 'datetime',
        tickInterval: 24 * 3600 * 1000,
        labels: {
          step: 7,
          formatter: function(){
            return(Highcharts.dateFormat('%b %e',this.value));
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
        formatter: function(){
          return(Highcharts.dateFormat('%B %e, %Y',this.x) + ': <b>$' + Highcharts.numberFormat(this.y, 0, '', ',')+'</b>');
        }
      },
      series: series
    }

    const spendingMonth = new Highcharts.Chart(config)
  }
}
