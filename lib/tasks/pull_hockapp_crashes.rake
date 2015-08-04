namespace :hockapp do

  desc "pull all crashes"
  task :pull_crashes => :environment do
    client = HockeyApp.build_client
    app = client.get_apps.first
    crash_groups = client.get_crash_groups app

    crash_groups.each do |res|
      crash_group = CrashGroup.new
      crash_group.file = res.file
      crash_group.reason = res.reason
      crash_group.status = res.status
      crash_group.hockey_id = res.id
      crash_group.crash_class = res.crash_class
      crash_group.bundle_version = res.bundle_version
      crash_group.last_crash_at = res.last_crash_at
      crash_group.app_version_id = res.app_version_id
      crash_group.method = res.method
      crash_group.bundle_short_version = res.bundle_short_version
      crash_group.number_of_crashes = res.number_of_crashes
      crash_group.line = res.line
      crash_group.fixed = res.fixed
      crash_group.hockey_updated_at = res.updated_at
      crash_group.hockey_created_at = res.created_at
      crash_group.save

      crashes = client.get_crashes_for_crash_group res
      crashes.each do |crash|
        c_new = Crash.new()
        c_new.crash_group_id = crash_group.id
        c_new.hockey_id = crash.id
        c_new.hockey_version_id = crash.app_version_id
        c_new.hockey_crash_group_id = crash.crash_reason_id
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
  end

end