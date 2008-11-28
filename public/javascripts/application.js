function insert_default(element) {
  if($(element).attr('value') == ''){
    $(element).addClass('defaulted');
    $(element).attr('value', $(element).attr('default'));
  }
}

$(window).load(function(){
  $('input#thing').focus();
});

$(document).ready(function() {
  
  $('a[rel*=facebox]').facebox();
  
  $('.date_selector select').change(function(){
    $(this).parent().submit();
  });
  
  $('table.sortable').tablesorter();
  
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

