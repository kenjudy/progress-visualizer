ready = ->

  $("a.tip").tooltip()

  $('.carousel').carousel('cycle')

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


  $("#user_profile_duration").change ->
    if $("#user_profile_duration").val() > 7
      $(".date-select").css("visibility", "visible")
    else
      $(".date-select").css("visibility", "hidden")

spinnerOn = ->
  $("#spinner").modal('show')

spinnerOff = ->
  $("#spinner").modal('hide')

window.tickUpdate = ->
  $.get "/chart/burn-up-reload", (data) ->
    timestamp =  Date.parse(data["last_update"])
    if (timestamp > window.last_timestamp)
      $.get "/chart/burn-up.json", (data) ->
        $.each data, (key, value) ->
          window.redraw_chart(key, value["data_table"], value["options"])
    else
      window.last_timestamp = timestamp
  setTimeout (->
    window.tickUpdate();
    ), 6000

window.redraw_chart = (chart_id, chart_data, chart_options) ->
  data_table = new google.visualization.DataTable()
  
  $.each chart_data["cols"], (index, col) ->
    data_table.addColumn
      type: col["type"]
      label: col["label"]

  $.each chart_data["rows"], (index, row) ->
    row[0]["v"] = new Date(row[0]["v"])
    data_table.addRow [row...]

  chart = new google.visualization.AreaChart(document.getElementById(chart_id))
  chart.draw data_table, chart_options
  return

$(window).resize ->
  $(".chart").each (index) ->
    eval("draw_" + @id + "()")
    return


$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:fetch', spinnerOn)
$(document).on('page:receive', spinnerOff)
