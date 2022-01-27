# frozen_string_literal: true

require 'csv'
require 'time'
require 'date'

def display_welcome_message
end

def import_data(filename)
  data = CSV.open(
    filename,
    headers: true,
    header_converters: :symbol
  )
  puts "\nData successfully loaded!\n"
  data
rescue StandardError
  puts "\nUnable to load data.\n"
end

def ask_for_desired_number_of_results
  puts "Let's see when most people respond.\n"\
  'Please enter the desired number of results (Top 3, Top 1, etc.)'
  top_n = gets.chomp.to_i
  puts "Got it! Looking for the top #{top_n} results:"
  top_n
rescue StandardError
  puts "Sorry, I didn't understand that. Please try again"
end

def get_dates_and_times(data)
  data.map { |row| Time.strptime(row[:regdate], '%m/%d/%y %H:%M') }
end

def find_most_common_occurrences(list, top_n)
  list.uniq.max_by(top_n) { |item| list.count(item) }
end

def find_peak_hours(dates_and_times, top_n)
  find_most_common_occurrences(dates_and_times.map(&:hour), top_n)
    .map { |result| Time.strptime(result.to_s, '%H') }
end

def find_peak_weekdays(dates_and_times, top_n)
  find_most_common_occurrences(dates_and_times.map(&:wday), top_n)
    .map { |result| Date::DAYNAMES[result] }
end

def display_peak_hours(peak_hours, top_n)
  puts "\nHere are the top #{top_n} most responsive hours:"
  peak_hours.each do |peak_hour|
    puts peak_hour.strftime(' > %l:00 to %l:59 %P')
  end
end

def display_peak_weekdays(peak_weekdays, top_n)
  puts "\nHere are the top #{top_n} most responsive days:"
  peak_weekdays.each { |peak_weekday| puts ' > ' + peak_weekday }
end

system 'clear'
puts "Time Targeter Initialized!\n"
filename = 'event_attendees.csv'
data = import_data(filename)
top_n = ask_for_desired_number_of_results
dates_and_times = get_dates_and_times(data)
peak_hours = find_peak_hours(dates_and_times, top_n)
peak_weekdays = find_peak_weekdays(dates_and_times, top_n)
display_peak_hours(peak_hours, top_n)
display_peak_weekdays(peak_weekdays, top_n)
