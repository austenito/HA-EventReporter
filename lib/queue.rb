require 'validator'
require 'printer'
require 'attendee_queue'
require 'find'
require 'result'

# Used to execute Queue methods such as printing and queue math.
class Queue
  attr_reader :attendee_queue, :printer

  def initialize(attendee_queue, printer= Printer.new)
    @attendee_queue = attendee_queue
    @printer = printer
  end

  def queue(args)
    if Validator.valid?("queue", args)
      args = args.split
      action = args[0]

      case action
      when "print" then print(args)
      when "save" then save(args)
      when "count" then Result.ok(attendee_queue.count)
      when "clear" then clear(args)
      end
    else
      Result.fail
    end
  end

  def subtract(args)
    if Validator.valid?("subtract", args)
      results = query_params(args) do |params|
        Find.find_matches(attendee_queue.filtered_attendees, params)
      end
      remove_count = results.inject(0) do |count, result|
        attendee_queue.remove(result)
        count += 1
      end
      Result.ok(remove_count)
    end
  end

  def add(args)
    if Validator.valid?("add", args)
      results = query_params(args) do |params|
        Find.find_matches(attendee_queue.all_attendees, params)
      end
      add_count = results.inject(0) do |count, result|
        attendee_queue.append(result)
        count += 1
      end
      Result.ok(add_count)
    end
  end

  private

  def print(args)
    if args.length == 3 then attendee_queue.sort_by(args.last) end
    printer.print(attendee_queue.filtered_attendees)
  end

  def save(args)
    filename = args[2..-1].join(" ")
    printer.save_to(attendee_queue.filtered_attendees, filename)
  end

  def clear(args)
    attendee_queue.clear
    Result.ok
  end

  def query_params(args)
    args_array = args.split
    args_array.shift
    params = Find.map_find(args_array.join(" "))
    yield params
  end
end
