$:.unshift File.dirname(__FILE__)
require 'csv'
require 'attendee'
require 'find_command'
require 'queue_command'

class EventReporter 
  DEFAULT_FILE = "../data/event_attendees.csv"
  attr_reader :find_command, :queue_command, :queue, :all_attendees

  def initialize
    @find_command = FindCommand.new
    @queue = Queue.new
    @queue_command = QueueCommand.new(@queue)
    @all_attendees = []
  end

  def run
    printf "Enter file to load (Empty file loads event_attendees.csv): "
    user_command = gets
    user_command = user_command.strip

    filename = DEFAULT_FILE if user_command.length == 0
    file = CSV.open(filename, {:headers => true, :header_converters => :symbol})

    attendees = []
    file.each do |line|
      record = line.to_hash
      all_attendees << Attendee.new(record)
    end

    while user_command != "q"
      printf "Enter command: "
      user_command = gets
      puts "full command: #{user_command}"
      execute(user_command)
    end
  end

  def execute(user_input)
    command = parse_command(user_input)
    args = parse_args(user_input)

    if Validator.is_valid(command, args)
      case command
      when "find"
        if find_command.is_valid?(params)
          attendees = find_command.find(all_attendees, params)
          puts attendees.length
          queue.add(attendees)
        else 
          puts "hakdjfldflajdfj"
        end
      when "queue"
        #if "print" 
        #else "save"
        #count
        #clear
      when "load"
        # do loader
      end
    else 
      #if queue_command.is_valid?(params)
      #queue_command.run(params)
      #end
      puts "Print help"
    end
  end

  def parse_command(input)
    input = user_input.split.first
    user_command.match(/find$|queue$/)
  end

  def parse_args(input)
    params = user_input.split
    params.shift
    params.join(" ")
  end

  r = EventReporter.new
  r.run
