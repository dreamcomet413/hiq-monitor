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
    @crashes = Crash.group_by_day(:hockey_created_at, range: @from..@to).count.map do |date, count|
      crash_group_ids = Crash.where(created_at: date.to_date.beginning_of_day..date.to_date.end_of_day).pluck(:crash_group_id)
      tags = CrashGroup.where(hockey_id: crash_group_ids).tag_counts_on(:tags).map { |t| {name: t.name, count: t.taggings_count} }
      [(date.to_f * 1000).to_i, count, tags.to_json]
    end
    render json: @crashes
  end

  def get_period
    @from = params[:from] ? Date.parse(params[:from]) : Date.today - 30.days
    @to = params[:to] ? Date.parse(params[:to]) : Date.today
    @to = @to.end_of_day
  end
end