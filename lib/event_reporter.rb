$:.unshift File.dirname(__FILE__)
require 'attendee'
require 'queue'
require 'commands'
require 'validator'

# The entry point for the EventReport CLI program
class EventReporter
  attr_reader :commands

  def initialize
    @commands = Commands.new
  end

  def run
    puts "\nWelcome to Event Reporter."
    begin
      printf "Enter command > "
      user_command = gets.strip
      @commands.run(user_command) unless user_command == "quit"
    end while user_command != "quit"
    puts "Goodbye."
  end
end

r = EventReporter.new
r.run
