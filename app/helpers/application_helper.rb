module ApplicationHelper
 
  def tooltip(tip, placement="right")
    concat "<a class=\"tip\" href=\"#\" data-toggle=\"tooltip\" data-placement=\"#{placement}\" title=\"#{tip}\" data-original-title=\"#{tip}\" data-container=\"body\"><span class=\"glyphicon glyphicon-question-sign\"></span></a>".html_safe
  end
  
  def menu_list_item(label, path)
    concat(content_tag(:li, link_to(raw(label), path), class: active_class_if(path)))
  end
  
  def active_class_if(paths)
    arr = paths.instance_of?(String) ? [paths] : paths
    "active" if arr.include?(request.fullpath)
  end
  
  def user_panel
    if current_user
      concat link_to("Logout #{content_tag(:span, current_user.name, class: "fit")}".html_safe, destroy_user_session_path, method: :delete)
    else
      concat link_to("Login", new_user_session_path)
    end
  end
end
