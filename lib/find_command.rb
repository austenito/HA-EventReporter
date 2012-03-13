class FindCommand
  VALID_ATTR = "regdate|first_name|last_name|email_address|homephone|" +
                "street|city|state|zipcode"

  def find(query, attendees)
    query_array = query.split
    attribute = query_array.shift
    criteria = query_array.join(" ")

    filtered_attendees = []
    attendees.each do |attendee|  
      if attendee.send(attribute) == criteria 
        filtered_attendees << attendee
      end
    end
    filtered_attendees
  end

  def is_valid?(query)
    (query =~ /(#{VALID_ATTR}) \w+/) == 0
  end
end
