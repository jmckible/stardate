$(document).ready(function() {
  
  $('a[rel*=facebox]').facebox();
  
  $('input[type=text][default]').livequery(function(){
    
    prompt_default(this);
    
    $(this).focus(function(){
      if($(this).attr('value') == $(this).attr('default')){
        $(this).removeClass('defaulted');
        $(this).attr('value', '');
      }
    });
    
    $(this).blur(function(){
      prompt_default(this);
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

function prompt_default(element) {
  if($(element).attr('value') == ''){
    $(element).addClass('defaulted');
    $(element).attr('value', $(element).attr('default'));
  }
}