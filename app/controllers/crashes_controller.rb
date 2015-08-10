class CrashesController < ApplicationController
  protect_from_forgery :except => [:webhook]

  def index
    @crashes = Crash.all
  end
end