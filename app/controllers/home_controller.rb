class HomeController < ApplicationController
  def index
    @crash_group_data = CrashGroup.all.map { |cg| {name: cg.hockey_id, y: cg.number_of_crashes} }
  end
end