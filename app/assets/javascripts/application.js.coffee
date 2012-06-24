//= require jquery
//= require jquery_ujs
//= require jquery_plugins
//= require facebox
//= require highcharts

insert_default = (element) ->
  if $(element).attr('value') == ''
    $(element).addClass('defaulted')
    $(element).attr('value', $(element).attr('default'))

$(window).load ->
  $('input#thing').focus()

$(document).ready ->
  
  $('a[rel*=facebox]').facebox()
  
  $('.hide').livequery ->
    $(this).hide()
  
  $('.date_selector select').change ->
    $(this).parent().submit()
  
  $('a.expand_note').click ->
    $(this).parent().hide()
    $(this).parent().next().show()
    event.preventDefault()
  
  $('.amortize .show a').livequery 'click', (event) ->
    $(this).parent().next().show()
    $(this).hide()
    event.preventDefault()
    
  # Form Defaults
  $('input[type=text][default]').livequery ->
    insert_default(this);
    $(this).focus ->
      if $(this).attr('value') == $(this).attr('default')
        $(this).removeClass('defaulted')
        $(this).attr('value', '')
    $(this).blur ->
      insert_default(this)
  
  $('form').livequery 'submit', (event) ->
    $(this).find('input[type=text][default]').each ->
      if $(this).attr('value') == $(this).attr('default')
        $(this).attr('value', '')
    return true;
