$:.unshift File.dirname(__FILE__)
require 'csv'
require 'attendee'
require 'find_command'
require 'queue_command'

class EventReporter 
  DEFAULT_FILE = "../data/event_attendees.csv"
  attr_reader :find_command, :queue_command

  def initialize
   @find_command = FindCommand.new
   @queue_command = QueueCommand.new
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
      attendees << Attendee.new(record)
    end

    while user_command != "q"
      printf "Enter command: "
      user_command = gets
      puts "full command: #{user_command}"
      execute(user_command)
    end
  end

  def execute(user_input)
    if user_input.length > 0
      user_command = user_input.split.first
      user_command = user_command.match(/print$|find$|queue$/)
      if user_command.nil?
        puts "Print help"
      else
        params = user_input.split
        params.shift
        params = params.join(" ")
        case user_command.to_s
        when "find"
          command = find_command
          #load it up.
        else 
          command = queue_command
        end

        if command.is_valid?(params)
          puts command.run(params)
        else
          puts "Print help"
        end
      end
    end
  end
end

r = EventReporter.new
r.run
