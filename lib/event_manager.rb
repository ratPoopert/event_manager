puts 'Event Manager Initialized!'

lines = File.readlines('event_attendees.csv')
lines.each_with_index do |line, index|
  # Skip the header row
  next if index == 0

  # Separate CSV columns
  columns = line.split(",")

  # Extract the name (third) column
  name = columns[2]
  puts name
end