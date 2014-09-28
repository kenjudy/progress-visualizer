module ConcernsHelper

  def board_label(prefix = 'for')
    if (@share)
      " #{prefix} #{@share.user_profile.name} Board"
    elsif (user_profile)
      " #{prefix} #{user_profile.name} Board"
    else
      ''
    end
  end

end