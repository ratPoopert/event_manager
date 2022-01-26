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

  # if the zip code is exactly five digits, assume that it is okay.
  # if the zip code is more than five digits, truncate it to the first five digits.
  # if the zip code is less than five digits, add zeros to the front until it becomes five digits.
  if zipcode.length < 5
    zipcode = zipcode.rjust(5, '0')
  elsif zipcode.length > 5
    zipcode = zipcode[0..4]
  end

  puts "#{name} #{zipcode}"
end
