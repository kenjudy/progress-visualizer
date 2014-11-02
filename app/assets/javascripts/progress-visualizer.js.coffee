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
      
  if $("#user_profile_readonly_token").length > 0 && $("#user_profile_readonly_token").val() == ""
    authorize()
    if(!Trello.authorized())
      $('#token-modal').modal('show')
  
  if $("#user_profile_current_sprint_board_id_short").length > 0 && $("#user_profile_current_sprint_board_id_short").val() == ""
    getBoardIds(Trello.token() || $("#user_profile_readonly_token").val())
   
  $("#token-modal .btn-primary").click (event) ->
    event.preventDefault()
    Trello.authorize(expiration: "never", name: "Progress Visualizer")
    
  $("#board_id_short_select select").change (event) ->
    $("#user_profile_name").val($("#board_id_short_select option:selected").text())
    
  $(".user_profiles form").submit (event) ->
    if $("#board_id_short_input input").length > 0 && $("#board_id_short_input input").val()?
      $("#board_id_short_select").empty()
    valid = validate()
    spinnerOn() if valid
    return valid
    
  $(".logout").click ->
    Trello.deauthorize()
    
  if $(".user_profiles.index #no-profiles").length > 0
    $('#profile-modal').modal('show')
    
authorize = ->
  Trello.authorize(interactive: false)
  if(Trello.authorized())
    $('#token-modal').modal('hide')
    $("#user_profile_readonly_token").val(Trello.token())

getBoardIds = (token) ->
  Trello.get("/tokens/"+Trello.token()+"/member/idBoards", listBoards)
  
listBoards = (boardIds) ->
  if boardIds.length > 0
    $("#board_id_short_select select").empty()
    $("#board_id_short_input").empty()
    $("#board_id_short_select").show()
    
  Trello.boards.get(id, addBoardToSelect) for id in boardIds
  
addBoardToSelect = (board) ->
  return if !board?
  idShort = board.shortUrl.replace(/https:\/\/trello.com\/b\//, "")
  $("#board_id_short_select select").append(new Option(board.name, idShort, false, false))  
  
validate = ->
  valid = validateField($("#user_profile_readonly_token")) && 
    validateField($("#user_profile_name")) && 
    validateField($("#board_id_short_input input")) &&
    validateField($("#user_profile_backlog_lists")) &&
    validateField($("#user_profile_done_lists"))
  $(".panel-footer .label-danger").show() if !valid
  return valid
    
validateField = (field) ->
  if field.length > 0 && field.val() == ""
    field.parents(".form-group").addClass("has-error")
    return false
  else
    return true
  
spinnerOn = ->
  $("#spinner").modal('show')

spinnerOff = ->
  $("#spinner").modal('hide')

window.tickUpdate = ->
  console.log('wake ' + window.last_timestamp)
  $.get "/chart/burn-up-reload", (data) ->
    timestamp =  Date.parse(data["last_update"])
    if (timestamp > window.last_timestamp)
      console.log('get ' + window.last_timestamp)
      $.get "/chart/burn-up.json", (data) ->
        $.each data, (key, value) ->
          console.log('call redraw ' + window.last_timestamp)
          window.redraw_chart(key, value["data_table"], value["options"])
          console.log('complete redraw ' + window.last_timestamp)
    else
      window.last_timestamp = timestamp
      console.log('tick ' + window.last_timestamp)
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

