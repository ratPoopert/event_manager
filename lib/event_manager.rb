require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = ENV["civic_info_key"]

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
      'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def decorate_phone_number(phone_number)
  area_code = phone_number[0..2]
  exchange_number = phone_number[3..5]
  subscriber_number = phone_number[6..9]
  return area_code + "-" + exchange_number + "-" + subscriber_number
end

def clean_phone_number(phone_number)
  clean_phone_number = phone_number.to_s.gsub(/[^0-9]/, '')
  if clean_phone_number.length == 10
    return decorate_phone_number(clean_phone_number)
  elsif clean_phone_number.length == 11 and clean_phone_number[0] == "1"
    return decorate_phone_number(clean_phone_number[1..])
  else
    return 'No phone number available.'
  end
end

puts 'Event Manager Initialized!'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  phone_number = clean_phone_number(row[:homephone])
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)
  puts phone_number
end
