require 'printer'
require 'csv'
require 'validator'
require 'help'
require 'loader'

# The object containing methods used to invoke commands on event reporter.
class Commands

  attr_reader :attendee_queue, :commands 

  def initialize(attendee_queue = AttendeeQueue.new, printer = Printer.new)
    @attendee_queue = attendee_queue
    queue = Queue.new(attendee_queue)
    @commands = {
      "load" => Loader.new(@attendee_queue),
      "help" => Help.new,
      "queue" => queue,
      "subtract" => queue,
      "add" => queue,
      "find" => Find.new(@attendee_queue) }
  end

  def run(user_input)
    if user_input == nil || user_input.empty?
      Help.print
    else
      user_input = user_input.downcase
      command, args = parse(user_input)

      if Validator.command_valid?(command)
        result = commands[command].send(command, args)
        
        if !result.nil? && result.success?
          value = result.value
          if command == "load" 
            puts "Loaded #{value}."
          elsif command == "find" 
            puts "Found #{value} records."
          elsif command == "subtract"
            puts "Removed #{value} records."
          elsif command == "add"
            puts "Added #{value} records."
          elsif command == "queue" 
            if args.include?("count") then puts "#{value} records." end
            if args.include?("clear") then puts "Cleared queue." end
            if args.include?("save") then puts "Saved records to: #{value}" end
          end
        else
          unless result.nil?
            case result.value
            when :invalid_file then puts "File is invalid."
            end
          else
            Help.print
          end
        end
      else
      end
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
