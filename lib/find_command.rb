class FindCommand
  VALID_ATTR = "regdate|first_name|last_name|email_address|homephone|" +
                "street|city|state|zipcode"

  def find(query, attendees)
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

  def is_valid_query?(query)
    (query =~ /find (#{VALID_ATTR}) \w+/) == 0
  end
end
