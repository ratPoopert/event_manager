require 'csv'
require 'time'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  registration_date_and_time = Time.strptime(row[:regdate], "%m/%d/%y %H:%M")
  p registration_date_and_time
end