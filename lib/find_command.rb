class FindCommand

  def self.find(query, attendees)
    elements = query.split
    key = elements[0]
    value = elements[1] 

    filtered_attendees = []
    attendees.each do |attendee|  
      if attendee.send(key) == value
        filtered_attendees << attendee
      end
    end
    filtered_attendees
  end
end
