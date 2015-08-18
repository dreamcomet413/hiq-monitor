class CrashGroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @crash_groups = CrashGroup.all
  end

  def show
    @crash_group = CrashGroup.find(params[:id])
    @crashes = @crash_group.crashes
  end

  def update
    @crash_group = CrashGroup.find(params[:id])
    @crash_group.tag_list = params[:tags]
    if @crash_group.save
      render json: @crash_group
    else
      render json: { error: "Can't update tags", status: 422 }
    end
  end
end
