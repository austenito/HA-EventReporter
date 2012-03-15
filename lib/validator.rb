class Validator
  ATTR = "regdate|first_name|last_name|email_address|homephone|" +
                "street|city|state|zipcode"

  def self.valid?(command, args)
    case command
    when "find"
      (args =~ /(#{ATTR}) \w+/) == 0
    when "queue"
      (args =~ /count$|clear$|print( by (#{ATTR}))?$|save to \w+(.\w+)?$/) == 0
    when "load"
      (args =~ /.+/) == 0
    when "subtract"
      (args =~ /find (#{ATTR}) \w+/) == 0
    when "add"
      (args =~ /find (#{ATTR}) \w+/) == 0
    when "help" then true
    else false
    end
  end

  def self.command_valid?(command)
    case command
    when "find" then true
    when "queue" then true
    when "load" then true
    when "subtract" then true
    when "add" then true
    when "help" then true
    end
  end
end
