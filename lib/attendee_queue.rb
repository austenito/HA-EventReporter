$:.unshift File.dirname(__FILE__)
require 'attendee'
require 'date'
require 'ruby-debug'

# The object used to store filtered_attendees.  Note: If add is called, this
# queue is cleared.
class AttendeeQueue
  attr_reader :filtered_attendees
  attr_accessor :all_attendees

  def initialize(all_attendees = Array.new, filtered_attendees = Array.new)
    @all_attendees = all_attendees
    @filtered_attendees = filtered_attendees
  end

  def count
   filtered_attendees.length
  end

  def clear
    filtered_attendees.clear
  end

  def add(new_attendees)
    filtered_attendees.clear
    @filtered_attendees += new_attendees
  end

  def append(attendee)
    filtered_attendees << attendee
  end

  def remove(attendee)
    filtered_attendees.delete(attendee)
  end

  def sort_by(attribute)
    @filtered_attendees = filtered_attendees.sort_by do |attendee|
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
