require 'printer'
require 'queue'
require 'attendee'
require 'csv'

class Commands 
  DEFAULT_FILE = File.dirname(__FILE__) + "/event_attendees.csv"
  attr_reader :attendee_queue, :printer, :help_hash
  attr_accessor :all_attendees
  def initialize(attendee_queue = Queue.new, printer = Printer.new)
    @attendee_queue = attendee_queue
    @printer = printer
    @all_attendees = []
    @help_hash = { "find" => "Load the queue with all records matching the " +
                             "criteria for the given attribute.", 
                   "queue" => {"print" => "Print out a tab-delimited data" + 
                                           "table with a header row",
                               "print by" => "Print the data table sorted " +
                               "by the specified attribute like zipcode.",
                               "count" => "Output how many records are in " +
                                          "the current queue",
                               "clear" => "Empty the queue",
                               "save to" => "Export the current queue to " +
                                            "the specified filename as a CSV"},
                   "load" => "Erase any loaded data and parse the " +
                             "specified file. If no filename is given, " + 
                             "default to event_attendees.csv.",
                   "quit" => "Exit"}
  end

  def find(args)
    args = args.downcase
    args_array = args.split
    attribute = args_array.shift
    criteria = args_array.join(" ")

    filtered_attendees = []
    all_attendees.each do |attendee|  
      if attendee.send(attribute).to_s.downcase == criteria 
        filtered_attendees << attendee
      end
    end

    attendee_queue.clear
    attendee_queue.add(filtered_attendees)
    puts "Found #{filtered_attendees.length} records."
  end

  def queue(args)
    args = args.split
    action = args[0]

    case action
    when "print"
      if args.length == 3
        attendee_queue.sort_by(args.last)
      end
      printer.print(attendee_queue.attendees)
    when "save" then printer.save_to(attendee_queue.attendees, args.last)
    when "count" then attendee_queue.count
    when "clear" then attendee_queue.clear
    end
  end

  def load(filename)
    filename = DEFAULT_FILE if filename.length == 0
    if File.exists?(filename)
      store_attendees(filename) 
      puts "File \"#{filename}\" loaded"
      true
    else
      puts invalid_file(filename)
      false
    end
  end

  def store_attendees(filename)
    all_attendees.clear 
    file = CSV.open(filename, {:headers => true, :header_converters => :symbol})

    attendees = []
    file.each do |line|
      record = line.to_hash
      all_attendees << Attendee.new(record)
    end
  end
  
  def help(args)
    if args.length == 0
      print_help
    else
      args = args.split
      command = args.shift
      help_value = help_hash[command]

      help_text = nil
      case command
      when "queue"
        help_text = help_value[args.join(" ")]
      else
        help_text = help_hash[command] 
      end

      if help_text.nil?
        print_help 
      else
        puts help_text
      end
    end
  end

  def print_help
    puts "load - " + help_hash["load"]
    puts "find - " + help_hash["find"]
    puts "queue print - " + help_hash["queue"]["print"]
    puts "queue print by - " + help_hash["queue"]["print by"]
    puts "queue count - " + help_hash["queue"]["count"]
    puts "queue clear - " + help_hash["queue"]["clear"]
    puts "queue save to - " + help_hash["queue"]["save to"]
    puts "quit - " + help_hash["quit"]
  end

  def invalid_file(filename)
    "File (#{filename} doesn't exist.)"
  end
end
