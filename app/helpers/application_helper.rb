module ApplicationHelper
  
  def menu_list_item(label, path)
    concat(content_tag(:li, link_to(raw(label), path), class: active_class_if(path)))
  end
  
  def active_class_if(paths)
    arr = paths.instance_of?(String) ? [paths] : paths
    "active" if arr.include?(request.fullpath)
  end
  
  def user_panel
    concat current_user
  end
end
