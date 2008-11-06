$(document).ready(function() {
  
  $('a[rel*=facebox]').facebox();
  
  $('input[type=text][default]').livequery(function(){
    $(this).addClass('defaulted');
    $(this).attr('value', $(this).attr('default'));
    
    $(this).focus(function(){
      if($(this).attr('value') == $(this).attr('default')){
        $(this).removeClass('defaulted');
        $(this).attr('value', '');
      }
    });
    
    $(this).blur(function(){
      if($(this).attr('value') == ''){
        $(this).addClass('defaulted');
        $(this).attr('value', $(this).attr('default'));
      }
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
