require 'result'

# The help command used to print useful information to users
class Help
  FIND = "find <attribute> <criteria>\n" +
    "\tLoad the queue with all matching records.\n"+
    "\tAttributes: regdate, first_name, last_name, email_address, " +
    "homephone, street, city, state, zipcode\n"
  PRINT = "queue print\n" +
    "\tPrint out a tab-delimited data table with a header row\n"
  PRINT_BY =  "queue print by <attribute>\n" +
    "\tPrint the data table sorted by the attribute\n"
  COUNT =  "queue count\n" +
    "\tOutput how many records are in the current queue\n"
  CLEAR = "queue clear\n\tEmpties the queue\n"
  SAVE_TO =  "queue save to <filename>\n" +
    "\tExport the current queue to the specified filename as a CSV\n"
  LOAD = "load <filename>\n" +
    "\tErase any loaded data and parse the specified file. If no " +
    "filename is given, default to event_attendees.csv.\n"
  SUBTRACT = "subtract find <attribute> <criteria>\n" +
    "\tRemoves the records found with the specified query\n"
  ADD = "add find <attribute> <criteria>\n" +
    "\tAdds the records found with the specified query\n"
  QUIT = "quit\n\tQuit Event Reporter :(\n"
  HELP = {
    "find" => FIND,
    "queue" => { "print" => PRINT, "print by" => PRINT_BY, "count" => COUNT,
    "clear" => CLEAR, "save to" => SAVE_TO }, "load" => LOAD ,"quit" => QUIT ,
    "subtract" => SUBTRACT, "add" => ADD }


  def help(args)
    if args.length == 0
      Help.print
    else
      args = args.split
      command = args.shift
      help_value = HELP[command]

      help_text = nil
      case command
      when "queue" then help_text = help_value[args.join(" ")]
      else help_text = HELP[command]
      end

      if help_text.nil?
        Help.print
      else puts "\n#{help_text}"
      end
    end
    Result.ok
  end

  def self.print
    puts "\n====HELP MENU====\n"
    puts HELP["load"]
    puts HELP["find"]
    puts HELP["add"]
    puts HELP["subtract"]
    puts HELP["queue"]["print"]
    puts HELP["queue"]["print by"]
    puts HELP["queue"]["count"]
    puts HELP["queue"]["clear"]
    puts HELP["queue"]["save to"]
    puts HELP["quit"]
    puts
  end
end
