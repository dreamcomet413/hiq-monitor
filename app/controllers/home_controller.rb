class HomeController < ApplicationController
  before_filter :get_period

  def crash_group_data
    @crash_group_data = CrashGroup.where(hockey_created_at: @from..@to).group(:status).count
    @crash_group_data = @crash_group_data.to_a.map { |cg| {name: CrashGroup::STATUS[cg[0].to_i], y: cg[1]} }
    render json: @crash_group_data
  end

  def crash_group_clouding
    @crash_group_clouding = CrashGroup.where(hockey_created_at: @from..@to).tag_counts_on(:tags).map do |t|
      tagged_crash_groups = CrashGroup.where(hockey_created_at: @from..@to).tagged_with(t.name)
      { name: t.name, y: Crash.where(crash_group_id: tagged_crash_groups.pluck(:hockey_id)).count }
    end

    render json: @crash_group_clouding
  end

  def crash_data
    @crashes_data = []
    @crashes_data << {name: 'All', data: Crash.all.daily_count(@from, @to)}
    @crashes_data += CrashGroup.where(hockey_created_at: @from..@to).tag_counts_on(:tags).map do |t|
      tagged_crash_groups = CrashGroup.where(hockey_created_at: @from..@to).tagged_with(t.name)
      crashes = Crash.where(crash_group_id: tagged_crash_groups.pluck(:hockey_id))
      { name: t.name, data: crashes.daily_count(@from, @to), visible: false }
    end
    
    render json: @crashes_data
  end

  private
  def get_period
    @from = params[:from] ? Date.parse(params[:from]) : Date.today - 30.days
    @to = params[:to] ? Date.parse(params[:to]) : Date.today
    @to = @to.end_of_day
  end
end
