$:.unshift File.dirname(__FILE__)
require 'csv'
require 'attendee'

class Printer
  def print(attendees)
    header_format = "%-20s\t%-20s\t%-40s\t%-8s\t%-30s\t%-2s\t%-40s"
    puts sprintf(header_format, "LAST NAME", "FIRST NAME", "EMAIL", "ZIPCODE",
                "CITY", "STATE", "ADDRESS")
    attendees.each do |attendee|
      puts sprintf(header_format, attendee.last_name, attendee.first_name, 
                   attendee.email_address, attendee.zipcode.zipcode, 
                   attendee.city, attendee.state, attendee.street)
    end
  end

  def save_to(filename)
    puts "Please implement teh save"  
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
  end
end

p = Printer.new

#@file = CSV.open("../event_attendees.csv", {:headers => true, :header_converters => :symbol})
#attendees = []
#5.times do
  #line = @file.readline
  #record = line.to_hash
  #attendees << Attendee.new(record)
#end
#p.print(attendees)
