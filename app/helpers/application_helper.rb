module ApplicationHelper
  
  def active(path)
    path == request.fullpath ? "active" : ""
  end
  
  def user_panel
    concat raw(link_to raw("Logout<span class=\"fit\"> #{session[:user]}</span>"), "http://logout:logout@#{request.host}:#{request.port ? request.port : "80"}#{users_logout_path}") if session[:user]
  end
end
