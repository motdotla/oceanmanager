require File.dirname(__FILE__) + '/config/boot.rb'

include Clockwork

every(1.minute, 'text') do
  puts "hi there!"
  puts "="*100
end

every(2.minutes, 'document.done check') do
  time_ago  = (Time.now.utc-5.minutes).to_i * 1000 
  events    = Carve::Event.all({type: "document.done"}).events
  events.each do |event|
    puts event.id
    if event.created > time_ago
      puts "="*100
      puts "Event was created: #{event.id}"
      puts "  - send email here"
      puts "="*100
    end
  end
end
