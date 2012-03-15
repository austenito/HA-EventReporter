require 'printer'
require 'queue'
require 'attendee'
require 'csv'
require 'validator'

# The object containing methods used to invoke commands on event reporter.
class Commands
  DEFAULT_FILE = File.dirname(__FILE__) + "/event_attendees.csv"
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
  QUIT = "quit\n\tQuit Event Reporter :(\n"
  HELP = {
    "find" => FIND,
    "queue" => { "print" => PRINT, "print by" => PRINT_BY, "count" => COUNT,
    "clear" => CLEAR, "save to" => SAVE_TO }, "load" => LOAD ,"quit" => QUIT }

  attr_reader :attendee_queue, :printer
  attr_accessor :all_attendees

  def initialize(attendee_queue = Queue.new, printer = Printer.new)
    @attendee_queue = attendee_queue
    @printer = printer
    @all_attendees = []
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
      when "save"
        filename = args[2..-1].join(" ")
        printer.save_to(attendee_queue.attendees, filename)
      when "count" then puts "#{attendee_queue.count} records."
      when "clear"
        attendee_queue.clear
        puts "Cleared queue."
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
        puts "Loaded \"#{filename}\"\n\n"
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
      help_value = HELP[command]

      help_text = nil
      case command
      when "queue"
        help_text = help_value[args.join(" ")]
      else
        help_text = HELP[command]
      end

      if help_text.nil?
        print_help
      else
        puts "\n#{help_text}"
      end
    end
  end

  private

  def store_attendees(filename)
    all_attendees.clear
    file = CSV.open(filename, {:headers => true,
                    :header_converters => :symbol})

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
    puts "\n====HELP MENU====\n"
    puts HELP["load"]
    puts HELP["find"]
    puts HELP["queue"]["print"]
    puts HELP["queue"]["print by"]
    puts HELP["queue"]["count"]
    puts HELP["queue"]["clear"]
    puts HELP["queue"]["save to"]
    puts HELP["quit"]
    puts
  end

  def invalid_file(filename)
    "File (#{filename} doesn't exist.)"
  end
end
