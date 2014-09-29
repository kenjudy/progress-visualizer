module ConcernsHelper  

  def board_label(prefix, profiles = [])
    if (profiles.length > 1)
      " #{prefix} All Boards"
    elsif (profiles.length == 1)
      " #{prefix} #{profiles.first.name} Board"
    elsif (@share)
      " #{prefix} #{@share.user_profile.name} Board"
    elsif (user_profile)
      " #{prefix} #{user_profile.name} Board"
    else
      ''
    end
  end

end