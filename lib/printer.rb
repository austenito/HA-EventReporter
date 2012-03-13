$:.unshift File.dirname(__FILE__)
require 'csv'
require 'attendee'

class Printer
  def print(attendees)
    puts "LAST NAME  FIRST NAME  EMAIL  ZIPCODE  CITY  STATE  ADDRESS"
    attendees.each do |attendee|
      puts attendee.last_name
    end
  end

  def save_to(filename)
    
  end
end

p = Printer.new

@file = CSV.open("../event_attendees.csv", {:headers => true, :header_converters => :symbol})
attendees = []
5.times do
  line = @file.readline
  record = line.to_hash
  record.delete(:_)
  attendees << Attendee.new(record)
end
p.print(attendees)
