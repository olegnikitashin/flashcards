desc "Task for users that have unrevised cards"
task mailer_feed: :environment do
  puts "Sending emails..."
  Card.expired_cards
  puts "Done."
end
