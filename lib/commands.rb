require 'printer'
require 'csv'
require 'validator'
require 'help'

# The object containing methods used to invoke commands on event reporter.
class Commands
  COMMANDS = {"help" => Help.new}
  DEFAULT_FILE = File.dirname(__FILE__) + "/event_attendees.csv"

  attr_reader :attendee_queue, :printer
  attr_accessor :all_attendees

  def initialize(attendee_queue = AttendeeQueue.new, printer = Printer.new)
    @attendee_queue = attendee_queue
    @printer = printer
    @all_attendees = []
  end

  def run(user_input)
    user_input = user_input.downcase
    command, args = parse(user_input)

    if Validator.command_valid?(command)
      COMMANDS[command].send(command, args)
  #send(command, args)
      #puts COMMANDS[command]
    else
      ##print_help
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
      #print_help
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

  def parse(input)
    inputs = []
    params = input.split
    inputs << params.shift
    inputs << params.join(" ")
  end

  def invalid_file(filename)
    "File (#{filename} doesn't exist.)"
  end
end
