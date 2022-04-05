import { Controller } from '@hotwired/stimulus'
import Highcharts from 'highcharts'

export default class extends Controller {

  static values = { workout: Array, weights: Array, startDay: Number, startMonth: Number, startYear: Number }

  connect() {
    const config = {
      chart: {
        renderTo: 'HealthYear'
      },
      title:  { text: false },
      legend: { enabled: false },
      yAxis:[
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
        tickInterval: 7 * 24 * 3600 * 1000,
        labels: {
          step: 4,
          formatter: function(){
            return(Highcharts.dateFormat('%b %e',this.value));
          }
        }
      },
      series: [{
        type: 'column',
        name: 'Exercise',
        data: this.workoutValue,
        pointInterval: 7 * 24 * 3600 * 1000,
        pointStart: Date.UTC(this.startYearValue, this.startMonthValue, this.startDayValue),
        yAxis: 0,
        pointWidth: 10,
        pointPadding: 0,
        color: '#00CCFF'
      }, {
        type: 'spline',
        name: 'Weight',
        data: this.weightsValue,
        pointInterval: 7 * 24 * 3600 * 1000,
        pointStart: Date.UTC(this.startYearValue, this.startMonthValue, this.startDayValue),
        yAxis: 1,
        color: '#FF00CC'
      }]
    }

    const healthMonth = new Highcharts.Chart(config)

  }
}
