import { Controller } from '@hotwired/stimulus'
import Highcharts from 'highcharts'

export default class extends Controller {

  static values = { workout: Array, weights: Array, startDay: Number, startMonth: Number, startYear: Number }

  connect() {

    const config = {
      chart: {
        renderTo: this.element,
        width: 400,
        height: 280
      },
      credits: {
        enabled: false
      },
      title:  { text: undefined },
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
        tickInterval: 24 * 3600 * 1000,
        labels: {
          step: 7,
          formatter: function(){
            return(Highcharts.dateFormat('%b %e',this.value));
          }
        }
      },
      plotOptions:{
        spline:{
          marker: {
            enabled: false
          },
          shadow: false
        },
        column:{
          stacking: 'normal',
          shadow: false,
          pointWidth: 10,
          pointPadding: 0
        }
      },
      series: [{
        type: 'column',
        name: 'Workout',
        data: this.workoutValue,
        pointInterval: 24 * 3600000,
        pointStart: Date.UTC(this.startYearValue, this.startMonthValue, this.startDayValue),
        yAxis: 0,
        color: '#F0F'
      },{
        type: 'spline',
        name: 'Weight',
        data: this.weightsValue,
        pointInterval: 24 * 3600000,
        pointStart: Date.UTC(this.startYearValue, this.startMonthValue, this.startDayValue),
        yAxis: 1,
        lineWidth: 4
      }]
    }
    const healthMonth = new Highcharts.Chart(config)
  }

}
