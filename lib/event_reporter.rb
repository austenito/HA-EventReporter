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
    printf "Enter file to load (Empty file loads event_attendees.csv): "
    user_command = gets
    user_command = user_command.strip
    commands.load(user_command)

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
end

  r = EventReporter.new
  r.run
