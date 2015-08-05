notifier = Slack::Notifier.new "https://hooks.slack.com/services/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", 
                                channel: '#hockeyapp-notifier',
                                username: 'hockeyappnotifier'
# notifier.ping "Hello default"                                
# notifier.ping "feeling spooky", icon_emoji: ":ghost:"
# notifier.ping "feeling chimpy", icon_url: "http://static.mailchimp.com/web/favicon.png"
# a_ok_note = {
#   fallback: "Everything looks peachy",
#   text: "Everything looks peachy",
    
# }
# # notifier.ping "with an attachment", attachments: [a_ok_note]

# notifier = Slack::Notifier.new 'https://hooks.slack.com/services/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', 
#                                 http_options: { open_timeout: 5 }
# notifier.ping "hello", http_options: { open_timeout: 10 }