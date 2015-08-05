class HomeController < ApplicationController
  def index
    @crash_group_data = CrashGroup.group(:status).count
    @crash_group_data = @crash_group_data.to_a.map { |cg| {name: CrashGroup::STATUS[cg[0].to_i], y: cg[1]} }
  end
end