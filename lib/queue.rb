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
    attendees << new_attendees
  end
end
