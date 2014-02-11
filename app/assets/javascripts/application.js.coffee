# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap
#= require_tree .


$ ->
  $(window).resize ->
    $(".chart").each (index) ->
      eval("draw_" + @id)
      return
      
  $("a.tip").tooltip()
  
window.tickUpdate = ->
  $.get "/chart/burn-up-reload", (data) ->
    timestamp =  Date.parse(data["last_update"])
    if (timestamp > window.last_timestamp)
      window.location.reload()
    else
      window.last_timestamp = timestamp
  setTimeout (->
    window.tickUpdate();
    ), 30000