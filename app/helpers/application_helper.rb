module ApplicationHelper
  
  def active(path)
    path == request.fullpath ? "active" : ""
  end
end
