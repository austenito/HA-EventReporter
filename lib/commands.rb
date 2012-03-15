require 'printer'
require 'queue'
require 'attendee'
require 'csv'
require 'validator'

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

  def run(user_input)
    user_input = user_input.downcase
    command, args = parse(user_input)

    if Validator.command_valid?(command)
      send(command, args) 
    else 
      print_help
    end
  end

  def find(args)
    params = map_find(args)
    if params.any?
      filtered_attendees = find_matches(@all_attendees, params)
      attendee_queue.add(filtered_attendees)
      puts "Found #{filtered_attendees.length} records."
    else
      print_help  
    end
  end

  def find_matches(attendees, params)
    filtered_attendees = []
    attendees.each do |attendee|  
      match = params.all? do |attribute, criteria| 
        attendee.send(attribute).to_s.downcase == criteria 
      end
      filtered_attendees << attendee if match
    end
    filtered_attendees
  end

  def subtract(args)
    if Validator.valid?("subtract", args)

      results = query_params(args) do |params|
        find_matches(@attendee_queue.attendees, params)
      end
      remove_count = results.inject(0) do |count, result| 
        @attendee_queue.remove(result) 
        count += 1
      end
      puts "Removed #{remove_count} records."
    else
      print_help
    end
  end

  def add(args)
    if Validator.valid?("add", args)
      results = query_params(args) do |params|
        find_matches(@all_attendees, params)
      end
      add_count = results.inject(0) do |count, result| 
        @attendee_queue.append(result) 
        count += 1
      end
      puts "Added #{add_count} record."
    else
      print_help
    end
  end

  def query_params(args)
    args_array = args.split
    args_array.shift 
    params = map_find(args_array.join(" "))
    yield params
  end

  def queue(args)
    if Validator.valid?("queue", args)
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
    else
      print_help
    end
  end

  def load(filename)
    filename = DEFAULT_FILE if filename.length == 0
    if Validator.valid?("load", filename)
      if File.exists?(filename)
        store_attendees(filename) 
        puts "File \"#{filename}\" loaded"
        true
      else
        puts invalid_file(filename)
        false
      end
    else 
      print_help
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

  private

  def store_attendees(filename)
    all_attendees.clear 
    file = CSV.open(filename, {:headers => true, :header_converters => :symbol})

    attendees = []
    file.each do |line|
      record = line.to_hash
      all_attendees << Attendee.new(record)
    end
  end

  def map_find(args)
    clauses = args.split("and") 
    params = {}
    clauses.each do |clause|
      clause = clause.strip
      if Validator.valid?("find", clause)
        args_array = clause.split
        attribute = args_array.shift
        criteria = args_array.join(" ")
        params[attribute] = criteria
      else
        return {}
      end
    end
    params
  end

  def parse(input)
    inputs = []
    params = input.split
    inputs << params.shift
    inputs << params.join(" ")
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
