$:.unshift File.dirname(__FILE__)
require 'csv'
require 'attendee'

class EventReporter 
  DEFAULT_FILE = "../data/event_attendees.csv"
  #def output_data(filename)
    #output = CSV.open(filename, "w")
    #@file.each do |line|
      #if @file.lineno == 2
        #output << line.headers
      #end
      #line[:homephone] = clean_phone_numbers(line[:homephone])
      #line[:zipcode] = clean_zipcodes(line[:zipcode])
      #output << line
    #end
  #end

  def run
    printf "Enter file to load (Empty file loads event_attendees.csv): "
    user_command = gets
    user_command = user_command.strip

    filename = DEFAULT_FILE if user_command.length == 0
    file = CSV.open(filename, {:headers => true, :header_converters => :symbol})

    attendees = []
    5.times do
      line = file.readline
      record = line.to_hash
      attendees << Attendee.new(record)
    end

    while user_command != "q"
      printf "Enter command: "
      user_command = gets
      puts "full command: #{user_command}"
      commands = user_command.split
      command = commands[0]
    end
  end
end

r = EventReporter.new
r.run
