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
  
  $('.carousel').carousel('cycle')
      
  $("a.tip").tooltip()
  
  $(".cloud-selector").click (event) ->
    element = $(this)
    display_field = element.parent(".panel-body").parent(".panel").children(".panel-footer").children("textarea")
    data_field = element.parent(".panel-body").parent(".panel").children(".panel-footer").children("input")
    if (element.hasClass("btn-default"))
      element.removeClass("btn-default")
      element.addClass("btn-info")
      display_field.val([display_field.val(), element.text()].join(","))
    else
      element.removeClass("btn-info")
      element.addClass("btn-default")
      display_field.val(display_field.val().replace(new RegExp(element.text()), ""))
    display_field.val(display_field.val().replace(/^,|,$|/g, ""))
    display_field.val(display_field.val().replace(/,,/g, ","))
  
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