class FindCommand
  VALID_ATTR = "regdate|first_name|last_name|email_address|homephone|" +
                "street|city|state|zipcode"

  def find(attendees, query)
    query_array = query.split
    attribute = query_array.shift
    criteria = query_array.join(" ")

    filtered_attendees = []
    attendees.each do |attendee|  
      #puts attendee.send(attribute).to_s + " = " + criteria 

      if attendee.send(attribute).to_s == criteria 
        #yield to the block to save information?
        filtered_attendees << attendee
      end
    end
    filtered_attendees
  end
end
