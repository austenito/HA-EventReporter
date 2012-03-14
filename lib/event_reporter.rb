$:.unshift File.dirname(__FILE__)
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
      if commands.load(user_command) then break end
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
      commands.print_help
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
end

r = EventReporter.new
r.run
