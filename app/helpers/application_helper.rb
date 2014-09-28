require 'redcarpet'

module ApplicationHelper

  def render_markdown(content)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
    markdown.render(content).html_safe
  end

  def date_pills(first_iteration, default_weeks, number_pills = 5)
    weeks_in_between_now_and_first_iteration = (Date.today - first_iteration) / 7
    interval_in_weeks = (weeks_in_between_now_and_first_iteration / number_pills).ceil
    ((1..number_pills).map { |index| index * interval_in_weeks } << default_weeks).sort
  end

  def card_link(card)
    card.card_id.present? ? link_to(card.id_short, cards_show_url(card_id: card.card_id)) : card.id_short
  end
  
  def duration_in_weeks(days)
    duration = days ? days / 7 : 1
    label = duration > 9 ? duration : %w(Zero One Two Three Four Five Six Seven Eight Nine)[duration]
    "#{label} week#{'s' if duration > 1}"
  end

  def tooltip(tip, placement="right")
    concat "<a class=\"tip\" href=\"#\" data-toggle=\"tooltip\" data-placement=\"#{placement}\" title=\"#{tip}\" data-original-title=\"#{tip}\" data-container=\"body\"><span class=\"glyphicon glyphicon-question-sign\"></span></a>".html_safe if tip
  end

  def menu_list_item(label, path, classes = "")
    concat(content_tag(:li, link_to(raw(label), path, onClick: track_event('header_menu', [label])), class: "#{active_class_if(path)} #{classes}"))
  end

  def track_event(action, optional_args = [])
    "_gaq.push(['_trackEvent', #{underscore_join_words(action)}, #{optional_args.collect { |arg| underscore_join_words(arg) }.join(",")}]);"
  end

  def underscore_join_words(label)
    "'#{label.underscore.gsub(" ", "_").gsub("'","")}'"
  end

  def active_class_if(paths)
    arr = paths.instance_of?(String) ? [paths] : paths
    "active" if arr.include?(request.fullpath.gsub(/\d{4}-\d{2}-\d{2}$|\d+$/, "").gsub(/\/?$/,""))
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
  
  def export_button(path)
    link_to raw("CSV <span class=\"glyphicon glyphicon-file\"></span>"), path, 
      alt: "Export to CSV file", title: "Export to CSV file", class: "btn btn-default hide-print" if path
  end
  
  def pagination(args)
    unless request.path.include?('/sharing/')
      render 'application/pagination', 
              prior_iteration: args[:prior_iteration],
              prior_path: reports_performance_summary_path(iteration: args[:prior_iteration]), 
              next_iteration: args[:next_iteration],
              next_path: reports_performance_summary_path(iteration: args[:next_iteration])
    end
  end
  
  def share_button
    unless request.path.include?('/sharing/')
      link_to raw("Share <span class=\"glyphicon glyphicon-share\"></span>"), "#", 
        alt: "Share report", title: "Share report", class: "btn btn-default hide-print sharing",
        "data-toggle" => "modal",  "data-target" => "#sharing-modal" if current_user
    end
  end
  
  def share_modal
    unless request.path.include?('/sharing/')
      render "application/sharing_modal", share_url: reports_sharing_new_path(iteration: @iteration, report: "performance-summary")
    end
  end
  
  def javascript_date_string(datetime)
     "new Date(#{ datetime.year }, #{ datetime.month - 1 }, #{ datetime.day }, #{ datetime.hour }, #{ datetime.minute }, #{ datetime.second })"
  end
  
end
