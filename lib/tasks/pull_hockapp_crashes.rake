require 'slack-notifier'

namespace :hockeyapp do
  desc "pull all crashes"
  @cur_get_minute = nil
  @cur_numgets_minute = 0
  task :pull_crashes => :environment do |t, args|
    client = HockeyApp.build_client
    app = client.get_apps.first
    page  = 1
    started_at = Time.now

    if ENV['notify_slack'] != 'false'
      notifier = Slack::Notifier.new ENV['SLACK_AUTH'],       
                                     channel: ENV['SLACK_CHANNEL'],
                                     username: ENV['SLACK_USERNAME']
    end

    while true do
      throttleReq()
      cgs_hockey = client.get_crash_groups app, { per_page: 100, page: page }
      break if cgs_hockey.empty?

      page += 1

      new_cg_ids = cgs_hockey.map(&:id) - CrashGroup.pluck(:hockey_id)
      new_cgs = cgs_hockey.select { |cg| new_cg_ids.include? cg.id }

      new_cgs.each do |new_cg|
        cg = CrashGroup.new
        cg.file = new_cg.file
        cg.reason = new_cg.reason
        cg.status = new_cg.status
        cg.hockey_id = new_cg.id
        cg.crash_class = new_cg.crash_class
        cg.bundle_version = new_cg.bundle_version
        cg.app_version_id = new_cg.app_version_id
        cg.method = new_cg.method
        cg.bundle_short_version = new_cg.bundle_short_version
        cg.number_of_crashes = 0
        cg.line = new_cg.line
        cg.fixed = new_cg.fixed
        cg.hockey_updated_at = new_cg.updated_at
        cg.hockey_created_at = new_cg.created_at
        cg.save

        if ENV['notify_slack'] != 'false'
          link = "https://rink.hockeyapp.net/manage/apps/78249/app_versions/#{cg.app_version_id}/crash_reasons/#{cg.hockey_id}"
          notifier.ping "New Crash Group (HiQ Monitor ID: #{cg.id}, Hockey ID: <#{link}|#{new_cg.id}>)",
                  icon_url: "http://static.mailchimp.com/web/favicon.png"
        end

      end

      cgs_hockey.each do |cg_hockey|
        cg = CrashGroup.find_by(hockey_id: cg_hockey.id)
        if cg_hockey.number_of_crashes < cg.number_of_crashes
          raise "ERROR: More crashes in db than available in crash group (HiQ Monitor ID: #{cg.id}, Hockey ID: #{cg_hockey.id})"
        end
        next if cg_hockey.last_crash_at == cg.last_crash_at || cg_hockey.number_of_crashes == cg.number_of_crashes 

        cpage = 1
        while true
          throttleReq()
          crashes = client.get_crashes_for_crash_group cg_hockey, { per_page: 100, page: cpage }
          break if crashes.empty?

          new_ids = crashes.map(&:id) - Crash.where(hockey_crash_group_id: cg_hockey.id).pluck(:hockey_id)
          new_crashes = crashes.select { |crash| new_ids.include? crash.id }
          puts "#{new_crashes.count} new crashes in crash_group #{cg_hockey.id}"

          new_crashes.each do |crash|
            break if Crash.where(hockey_id:cg_hockey.id).count > 0 # should never hit this condition since we are plucking above
            c_new = Crash.new()
            c_new.crash_group_id = cg_hockey.id
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
              link = "https://rink.hockeyapp.net/manage/apps/78249/app_versions/#{cg_hockey.app_version_id}/crash_reasons/#{cg_hockey.id}"
              notifier.ping "New Crash (HiQ Monitor ID: #{crash.id}, Hockey ID: <#{link}|#{cg_hockey.id})>", 
                      icon_url: "http://static.mailchimp.com/web/favicon.png"
            end
          end
          cg.last_crash_at = cg_hockey.last_crash_at
          cg.number_of_crashes = Crash.where(hockey_crash_group_id: cg_hockey.id).count
          cg.save
          cpage += 1
        end
      end
    end
    ended_at = Time.now
    puts "Elapsed seconds: #{(ended_at - started_at).to_i.abs} secs" 
  end

  def throttleReq()
    # 60 reqs per minute
    if @cur_get_minute.nil?
      @cur_get_minute = Time.now.min
      @cur_numgets_minute = 0
    elsif @cur_get_minute != Time.now.min
      @cur_get_minute = Time.now.min
      @cur_numgets_minute = 0
    elsif @cur_numgets_minute >= 58 #2, random margin
      puts("throttling...")
      sleep(62 - Time.now.sec) #2, random margin
    end
    @cur_numgets_minute += 1
    return
  end
end
