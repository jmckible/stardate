import Rails from 'rails-ujs';
Rails.start();

const Turbolinks = require('turbolinks');
Turbolinks.start();

require('jquery.facebox');

require('src/app');

require('charts/area');
