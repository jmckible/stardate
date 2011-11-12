//= require jquery
//= require jquery_ujs
//= require jquery_plugins
//= require facebox
//= require highcharts

function insert_default(element) {
  if($(element).attr('value') == ''){
    $(element).addClass('defaulted');
    $(element).attr('value', $(element).attr('default'));
  }
}

jQuery.tablesorter.addParser({
  id: "commaDigit",
  is: function(s, table) {
    var c = table.config;
    return jQuery.tablesorter.isDigit(s.replace(/,/g, ""), c);
  },
  format: function(s) {
    return jQuery.tablesorter.formatFloat(s.replace(/,/g, ""));
  },
  type: "numeric"
});

$(window).load(function(){
  $('input#thing').focus();
});

$(document).ready(function() {
  
  $('a[rel*=facebox]').facebox();
  
  $('.hide').livequery(function(){
    $(this).hide();
  })
  
  $('.date_selector select').change(function(){
    $(this).parent().submit();
  });
  
  $('a.expand_note').click(function(){
    $(this).parent().hide();
    $(this).parent().next().show();
    return false;
  });
  
  $('.amortize .show a').livequery('click', function(){
    $(this).parent().next().show();
    $(this).hide();
    return false;
  });
  
  $('table.sortable').tablesorter({textExtraction: 'commaDigit'});
  
  // Form Defaults
  $('input[type=text][default]').livequery(function(){
    insert_default(this);
    $(this).focus(function(){
      if($(this).attr('value') == $(this).attr('default')){
        $(this).removeClass('defaulted');
        $(this).attr('value', '');
      }
    });
    $(this).blur(function(){
      insert_default(this);
    });
  });
  $('form').livequery('submit', function(){
    $(this).find('input[type=text][default]').each(function(){
      if($(this).attr('value') == $(this).attr('default')){
        $(this).attr('value', '');
      }
    });
    return true;
  });

});

