$:.unshift File.dirname(__FILE__)
require 'attendee'
require 'date'

class Queue 
  attr_reader :attendees 

  def initialize(attendees = Array.new)
    @attendees = attendees 
  end

  def count
   attendees.length
  end

  def clear
    attendees.clear
  end

  def add(new_attendees)
    attendees.clear
    @attendees += new_attendees
  end

  def remove(attendees_to_remove)
    attendees_to_remove.each { |attendee| @attendees.delete(attendee) }
  end

  def sort_by(attribute)
    @attendees = attendees.sort_by do |attendee|
      value = attendee.send(attribute)
      case attribute
      when "zipcode"
        value.to_i
      when "homephone"
        value.to_i
      when "regdate"
        puts value
       DateTime.strptime(value, "%m/%d/%Y %H:%M")
      else
        value
      end
    end
  end
end
