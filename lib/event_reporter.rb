$:.unshift File.dirname(__FILE__)
require 'attendee'
require 'queue'
require 'commands'
require 'validator'

class EventReporter
  attr_reader :commands

  def initialize
    @commands = Commands.new
  end

  def run
    is_loaded = false
    begin
      puts "\nWelcome to Event Reporter."
      printf "Type file to load (Enter loads event_attendees.csv) > "
      user_command = gets.strip
      if commands.load(user_command) then break end
    end while user_command != "quit"

    while user_command != "quit"
      printf "Enter command > "
      user_command = gets.strip
      @commands.run(user_command) unless user_command == "quit"
    end

    puts "Goodbye."
  end
end

r = EventReporter.new
r.run
