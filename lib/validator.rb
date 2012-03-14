class Validator
  ATTR = "regdate|first_name|last_name|email_address|homephone|" +
                "street|city|state|zipcode"

  def self.is_valid?(command, args)
    command = command.downcase unless command.nil?
    args = args.downcase unless args.nil?
      
    case command
    when "find"
      (args =~ /(#{ATTR}) \w+/) == 0
    when "queue"
      (args =~ /count$|clear$|print( by (#{ATTR}))?$|save to \w+(.\w+)?$/) == 0
    when "load"
      (args =~ /.+/) == 0
    when "help" then true
    else false
    end
  end
end
