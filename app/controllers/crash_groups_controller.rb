class CrashGroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @crash_groups = CrashGroup.all
  end

  def show
    @crash_group = CrashGroup.find(params[:id])
    @crashes = @crash_group.crashes
  end
end
