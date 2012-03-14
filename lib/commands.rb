require 'printer'
require 'queue'
require 'attendee'

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
                             "default to event_attendees.csv." }
  end

  def find(args)
    args_array = args.split
    attribute = args_array.shift
    criteria = args_array.join(" ")

    filtered_attendees = []
    all_attendees.each do |attendee|  
      if attendee.send(attribute).to_s == criteria 
        filtered_attendees << attendee
      end
    end

    attendee_queue.clear
    attendee_queue.add(filtered_attendees)
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
      all_attendees.clear 
      file = CSV.open(filename, {:headers => true, :header_converters => :symbol})

      attendees = []
      file.each do |line|
        record = line.to_hash
        all_attendees << Attendee.new(record)
      end
      true
    else 
      false
    end
  end

  def help(args)
    if args.length == 0
    else
      args = args.split
      command = args.shift
      help_value = help_hash[command]

      case command
      when "queue"
        puts help_value[args.join(" ")]
      else
        puts help_hash[command] 
      end
    end
  end
end
