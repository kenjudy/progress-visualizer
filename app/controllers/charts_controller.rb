class ChartsController < ApplicationController
  include ChartsConcern
  include UserProfileConcern

  before_filter :authenticate_user!, :assign_user_profile
  before_filter :set_iteration, only: :burn_up

  def burn_up_reload
    render json: { last_update: Rails.cache.fetch(BurnUp.last_update_key(user_profile)) }.to_json
  end

  def burn_up
    factory = Factories::BurnUpFactory.new(user_profile)
    @stories_chart = stories_burn_up_visualization(factory, @iteration)

    if @stories_chart.data_table.rows.any?
      @estimates_chart = estimate_burn_up_visualization(factory, @iteration)
      @uses_estimates = has_non_zero_values(@estimates_chart)
    else
      flash.now[:notice] = "No burn up data.#{next_iteration_flash(@iteration)}"
    end

    @prior_iteration = user_profile.prior_iteration(@iteration)
    @next_iteration = user_profile.next_iteration(@iteration)

    respond_to do |format|
      format.html { render }
      format.json { render json: (@uses_estimates ? {estimates_chart: @estimates_chart} : {}).merge({stories_chart: @stories_chart}).to_json }
    end
  end

  def yesterdays_weather
    yesterdays_weather_action(user_profile, params[:weeks] ? params[:weeks].to_i : 3)
  end

  def long_term_trend
    @first_iteration = user_profile.first_iteration
    long_term_trend_action(user_profile, params[:weeks] ? params[:weeks].to_i : 10)
  end
  
  private
  
  def set_iteration
    @iteration = Date.parse(params["iteration"]) if params["iteration"]
  end
  
  def stories_burn_up_visualization(factory, iteration)
    stories_burn_up_data = factory.stories_burn_up_data(iteration)
    burn_up_chart_visualization({label: "Story Counts", data: stories_burn_up_data})
  end
  
  def estimate_burn_up_visualization(factory, iteration)
    estimate_burn_up_data = factory.estimates_burn_up_data(iteration)
    burn_up_chart_visualization({label: "Estimates", data: estimate_burn_up_data })
  end
  
  def next_iteration_flash(iteration)
    iteration ||= Date.today
    user_profile.between_iterations(iteration) ? " Next iteration starts at #{user_profile.beginning_of_iteration(iteration).strftime('%b %e, %l %p')}." : ""
  end

end
