# Load the CSV library
require 'csv'
puts 'Event Manager Initialized!'

# Load the CSV file using the CSV library.
contents = CSV.open(
  'event_attendees.csv',
  headers: true,

  # Convert headers to symbols
  header_converters: :symbol
)
contents.each do |row|
  # Access column via header name
  name = row[:first_name]
  zipcode = row[:zipcode]
  puts "#{name} #{zipcode}"
end
