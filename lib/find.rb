require 'attendee'
require 'attendee_queue'

class Find
  attr_reader :queue
  def initialize(queue = AttendeeQueue.new)
    @queue = queue
  end

  def find(args)
    params = Find.map_find(args)
    if params.any?
      filtered_attendees = find_matches(queue.all_attendees, params)
      queue.add(filtered_attendees)
      #puts "Found #{filtered_attendees.length} records."
    else
      #print_help
    end
  end

  def find_matches(attendees, params)
    filtered_attendees = []
    attendees.each do |attendee|
      match = params.all? do |attribute, criteria|
        attendee.send(attribute).to_s.downcase == criteria
      end
      filtered_attendees << attendee if match
    end
    filtered_attendees
  end

  def self.map_find(args)
    clauses = args.split("and")
    params = {}
    clauses.each do |clause|
      clause = clause.strip
      if Validator.valid?("find", clause)
        args_array = clause.split
        attribute = args_array.shift
        criteria = args_array.join(" ")
        params[attribute] = criteria
      else
        return {}
      end
    end
    params
  end
end
