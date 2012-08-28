# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$.money =
  fn:
    markup: 
      currency: (sel) ->
        $(sel).each (i, el) -> 
          $td = $(el)

          if !!$td.text().match(/^[0-9\-\$\.,]+$/) 
            $td.addClass('number')

          if !!$td.text().match(/^-?\$/) 
            $td.addClass('positive')

          if !!$td.text().match(/^-\$/) 
            $td.text( $td.text().replace(/^-/, '') )
            $td.addClass('negative')



$(document).ready ->
  $.money.fn.markup.currency( 'td' )
    
