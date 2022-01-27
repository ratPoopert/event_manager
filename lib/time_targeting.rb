require 'csv'
require 'time'

def display_welcome_message
  puts "Time Targeter Initialized!\n"
end

def import_data(filename)
  begin
    data = CSV.open(
      filename,
      headers: true,
      header_converters: :symbol
    )
    puts "\nData successfully loaded!\n"
    return data
  rescue
    puts "\nUnable to load data.\n"
  end
end

def ask_for_desired_number_of_results
  begin
    puts "Let's see which hours most frequently appear in the data.\n"\
    "Please enter the desired number of results (Top 3, Top 1, etc.)"
    top_n = gets.chomp.to_i
    puts "Got it! Looking for the top #{top_n} results:"
    return top_n
  rescue
    puts "Sorry, I didn't understand that. Please try again"
  end
end

def get_dates_and_times(data)
  data.map { |row| Time.strptime(row[:regdate], "%m/%d/%y %H:%M") }
end

def get_hours(dates_and_times)
  dates_and_times.map { |date_time| date_time.hour}
end

def find_most_common_occurrences(list, top_n)
  list.uniq.max_by(top_n) { |item| list.count(item) }
end

def find_peak_hours(dates_and_times, top_n)
  hours = get_hours(dates_and_times)
  results = find_most_common_occurrences(hours, top_n)
  results.map { |result| Time.strptime(result.to_s, "%H") }
end

def display_peak_hours(peak_hours, top_n)
  puts "Here are the top #{top_n} most responsive hours:"
  peak_hours.each do |peak_hour|
    puts peak_hour.strftime("%l:00 to %l:59 %P")
  end
end

display_welcome_message
filename = 'event_attendees.csv'
data = import_data(filename)
top_n = ask_for_desired_number_of_results
dates_and_times = get_dates_and_times(data)
hours = get_hours(dates_and_times)
peak_hours = find_peak_hours(dates_and_times, top_n)
display_peak_hours(peak_hours, top_n)