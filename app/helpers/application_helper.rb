module ApplicationHelper
 
  def tooltip(tip, placement="right")
    concat "<a class=\"tip\" href=\"#\" data-toggle=\"tooltip\" data-placement=\"#{placement}\" title=\"#{tip}\" data-original-title=\"#{tip}\" data-container=\"body\"><span class=\"glyphicon glyphicon-question-sign\"></span></a>".html_safe if tip
  end
  
  def menu_list_item(label, path, classes = "")
    concat(content_tag(:li, link_to(raw(label), path), class: "#{active_class_if(path)} #{classes}"))
  end
  
  def active_class_if(paths)
    arr = paths.instance_of?(String) ? [paths] : paths
    "active" if arr.include?(request.fullpath)
  end
  
  def time_options(hour)
    return options_for_select(time_array, hour)
  end
  
  def day_of_week(index)
    ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"][index]
  end
  
  def hour_format(index)
    time_array[index][0]
  end
  
  def time_array
    options = [["midnight", 0]]
    (1..11).each do |hour|
      options << ["#{hour} AM", hour]
    end
    options << ["noon", 12]
    (1..11).each do |hour|
      options << ["#{hour} PM", hour + 12]
    end
    return options
  end
  
  def user_profile
    @user_profile || UserProfile.new
  end
end
