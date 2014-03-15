class ChartsController < ApplicationController
  include ChartsConcern
  include UserProfileConcern
  include IterationConcern

  before_filter :authenticate_user!, :assign_user_profile

  def burn_up_reload
    render json: { last_update: Rails.cache.fetch(BurnUp.last_update_key(user_profile)) }.to_json
  end

  def burn_up
    @iteration = Date.parse(params["iteration"]) if params["iteration"]
    factory = Factories::BurnUpFactory.new(user_profile)
    stories_burn_up_data = factory.stories_burn_up_data(@iteration)
    @stories_chart = burn_up_chart_visualization({label: "Story Counts", data: stories_burn_up_data})

    if stories_burn_up_data.any?
      @estimates_chart = burn_up_chart_visualization({label: "Estimates", data:  factory.estimates_burn_up_data(@iteration)})
      @uses_estimates = has_non_zero_values(@estimates_chart)
    else
      flash.now[:notice] = "No burn up data.#{next_iteration_flash(@iteration)}"
      @uses_estimates = false
    end

    iteration = @iteration || beginning_of_current_iteration.strftime("%Y-%m-%d")
    @prior_iteration = prior_iteration(iteration)
    @next_iteration = next_iteration(iteration)

    respond_to do |format|
      format.html { render }
      format.json { render :json => (@uses_estimates ? {estimates_chart: @estimates_chart} : {}).merge({stories_chart: @stories_chart}).to_json }
    end
  end

  def yesterdays_weather
    yesterdays_weather_action(params[:weeks] ? params[:weeks].to_i : 3)
  end

  def long_term_trend
    long_term_trend_action(params[:weeks] ? params[:weeks].to_i : 10)
  end
  
  private
  
  def next_iteration_flash(iteration)
    iteration ||= Date.today
    between_iterations(iteration) ? " Next iteration starts at #{beginning_of_iteration(iteration).strftime('%b %e, %l %p')}." : ""
  end

end
