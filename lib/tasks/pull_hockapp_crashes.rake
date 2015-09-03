require 'slack-notifier'

namespace :hockeyapp do
  desc "pull all crashes"
  task :pull_crashes => :environment do |t, args|
    client = HockeyApp.build_client
    app = client.get_apps.first
    page  = 1
    started_at = Time.now

    if ENV['notify_slack'] != 'false'
      notifier = Slack::Notifier.new ENV['SLACK_AUTH'],       
                                     channel: ENV['SALCK_CHANNEL'],
                                     username: ENV['SLACK_USERNAME']
    end

    while true do 
      crash_groups = client.get_crash_groups app, { per_page: 100, page: page }
      break if crash_groups.empty?

      page += 1

      new_ids = crash_groups.map(&:id) - CrashGroup.pluck(:hockey_id)
      new_crash_groups = crash_groups.select { |cg| new_ids.include? cg.id }

      new_crash_groups.each do |res|
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
        binding.pry
        crash_group.save

        if ENV['notify_slack'] != 'false'
          notifier.ping "New Crash #{crash.id} has been occured in #{res.id} group.", 
                  icon_url: "http://static.mailchimp.com/web/favicon.png"
        end

      end

      crash_groups.each do |res|
        cpage = 1
        crash_group = CrashGroup.find_by(hockey_id: res.id)
        next if res.last_crash_at == crash_group.last_crash_at || res.number_of_crashes == crash_group.number_of_crashes 

        while true
          crashes = client.get_crashes_for_crash_group res, { per_page: 100, page: cpage }
          break if crashes.empty?

          new_ids = crashes.map(&:id) - Crash.where(hockey_crash_group_id: res.id).pluck(:hockey_id)
          new_crashes = crashes.select { |crash| new_ids.include? crash.id }
          puts "#{new_crashes.count} crashes in crash_group #{res.id}"

          new_crashes.each do |crash|
            c_new = Crash.new()
            c_new.crash_group_id = res.id
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
            if ENV['notify_slack'] != 'false'
              notifier.ping "New Crash #{crash.id} has been occured in #{res.id} group.", 
                      icon_url: "http://static.mailchimp.com/web/favicon.png"
            end
          end
          cpage += 1
        end
      end
    end
    ended_at = Time.now
    puts "Elapsed seconds: #{(ended_at - started_at).to_i.abs} secs" 
  end
end