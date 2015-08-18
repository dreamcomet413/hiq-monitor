class HomeController < ApplicationController
  def index
    @crash_group_data = CrashGroup.group(:status).count
    @crash_group_data = @crash_group_data.to_a.map { |cg| {name: CrashGroup::STATUS[cg[0].to_i], y: cg[1]} }
    @crash_group_clouding = CrashGroup.tag_counts_on(:tags).map { |t| {name: t.name, y: t.taggings_count} }
  end

  def crash_data
    from = Date.parse params[:from] || Date.today - 30.days
    to = Date.parse params[:to] || Date.today
    to = to.end_of_day
    @crashes = Crash.group_by_day(:hockey_created_at, range: from..to).count.map { |date, count| [(date.to_f * 1000).to_i, count] }
    render json: @crashes
  end
end