class Validator
  ATTR = "regdate|first_name|last_name|email_address|homephone|" +
                "street|city|state|zipcode"

  def self.is_valid?(command, args)
    case command
    when "find"
      (args =~ /(#{ATTR}) \w+/) == 0
    when "queue"
      (args =~ /count$|clear$|print( by (#{ATTR}))?$|save to \w+(.\w+)?$/) == 0
    else 
      false
    end
  end
end
