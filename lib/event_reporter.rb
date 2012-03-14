$:.unshift File.dirname(__FILE__)
require 'csv'
require 'attendee'
require 'queue'
require 'commands'
require 'validator'

class EventReporter 
  attr_reader :commands, :queue, :all_attendees

  def initialize
    @commands = Commands.new
    @queue = Queue.new
  end

  def run
    is_loaded = false
    begin
      printf "Enter file to load (Empty file loads event_attendees.csv): "
      user_command = gets.strip
      is_loaded = commands.load(user_command)
      if is_loaded then break end
      print_invalid_file(user_command) unless is_loaded || user_command == "quit"
    end while user_command != "quit"

    while user_command != "quit" 
      printf "Enter command: "
      user_command = gets.strip
      execute(user_command)
    end
  end

  def execute(user_input)
    command = parse_command(user_input)
    args = parse_args(user_input)

    if Validator.is_valid?(command, args)
      commands.send(command, args)
    else 
      #if queue_command.is_valid?(params)
      #queue_command.run(params)
      #end
      puts "Print help"
    end
  end

  def parse_command(input)
    input = input.split.first
  end

  def parse_args(input)
    params = input.split
    params.shift
    params.join(" ")
  end

  def print_invalid_file(filename)
    puts "File (#{filename} doesn't exist.)"
  end
end

  r = EventReporter.new
  r.run
