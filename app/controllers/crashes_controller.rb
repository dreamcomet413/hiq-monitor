class CrashesController < ApplicationController
  protect_from_forgery :except => [:webhook]

  def index
    @crashes = Crash.all
  end

  def webhook
    if params[:type] == 'crash_reason'
      client = HockeyApp.build_client
      app = client.get_apps.first

      crash_group = HockeyApp::CrashGroup.new(app, client)
      crash_group.id = 16273894 # params[:crash_reason][:id]

      # Retrieve all crashes by crash_group id
      crashes = client.get_crashes_for_crash_group crash_group
      crashes.each do |crash|
        c_new = Crash.new()
        c_new.hockey_id = crash.id
        c_new.hockey_version_id = crash.app_version_id
        c_new.crash_reason_id = crash.crash_reason_id
        c_new.oem = crash.oem
        c_new.model = crash.model
        c_new.bundle_version = crash.bundle_version
        c_new.bundle_short_version = crash.bundle_short_version
        c_new.os_version = crash.os_version
        c_new.jail_break = crash.jail_break
        c_new.contact = crash.contact_string
        c_new.user = crash.user_string
        c_new.hockey_updated_at = crash.updated_at
        c_new.hockey_created_at = crash.created_at
        c_new.save
      end
    end
    head :ok
  end
end