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

  def save_to(attendees, filename)
    output = CSV.open(filename, "w")
    is_top = true
    attendees.each do |attendee|
      attendee_hash = attendee.marshal_dump 
      output << attendee_hash.keys if is_top 
      is_top = false 
      output << attendee_hash.values
    end
    output.close
  end
end
