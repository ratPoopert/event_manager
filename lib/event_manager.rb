puts 'Event Manager Initialized!'

lines = File.readlines('event_attendees.csv')
lines.each do |line|

  # Separate CSV columns
  columns = line.split(",")

  # Extract the name (third) column
  name = columns[2]
  puts name
end