module ApplicationHelper
  
  def menu_list_item(label, path)
    concat(content_tag(:li, link_to(raw(label), path), class: active_class_if(path)))
  end
  
  def active_class_if(paths)
    arr = [paths] if paths.instance_of?(String)
    "active" if paths.include?(request.fullpath)
  end
  
  def user_panel
    concat raw(link_to raw("Logout<span class=\"fit\"> #{session[:user]}</span>"), "http://logout:logout@#{request.host}:#{request.port ? request.port : "80"}#{users_logout_path}") if session[:user]
  end
end
