# Load the CSV library
require 'csv'
puts 'Event Manager Initialized!'

# Load the CSV file using the CSV library.
contents = CSV.open('event_attendees.csv', headers: true)
contents.each do |row|
  name = row[2]
  puts name
end
