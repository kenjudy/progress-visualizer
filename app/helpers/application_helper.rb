module ApplicationHelper
  
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
