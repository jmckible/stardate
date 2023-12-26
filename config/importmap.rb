pin 'application',                                           preload: true
pin '@hotwired/turbo-rails',      to: 'turbo.min.js',        preload: true
pin '@hotwired/stimulus',         to: 'stimulus.min.js',     preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin "highcharts", to: "https://ga.jspm.io/npm:highcharts@10.0.0/highcharts.js"
pin_all_from 'app/javascript/controllers', under: 'controllers'

