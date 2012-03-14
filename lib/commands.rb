require 'printer'
require 'queue'
require 'attendee'

class Commands 
  DEFAULT_FILE = "../data/event_attendees.csv"
  attr_reader :all_attendees, :attendee_queue, :printer

  def initialize(attendee_queue = Queue.new, printer = Printer.new)
    @attendee_queue = attendee_queue
    @printer = printer
    @all_attendees = []
  end

  def find(args)
    args_array = args.split
    attribute = args_array.shift
    criteria = args_array.join(" ")

    filtered_attendees = []
    all_attendees.each do |attendee|  
      if attendee.send(attribute).to_s == criteria 
        filtered_attendees << attendee
      end
    end

    attendee_queue.clear
    attendee_queue.add(filtered_attendees)
  end

  def queue(args)
    args = args.split
    action = args[0]

    case action
    when "print"
      if args.length == 3
        attendee_queue.sort_by(args.last)
      end
      printer.print(attendee_queue.attendees)
    when "save" then printer.save_to(attendee_queue.attendees, args.last)
    when "count" then attendee_queue.count
    when "clear" then attendee_queue.clear
    end
  end

  def load(filename)
    all_attendees.clear 
    filename = DEFAULT_FILE if filename.length == 0
    file = CSV.open(filename, {:headers => true, :header_converters => :symbol})

    attendees = []
    file.each do |line|
      record = line.to_hash
      all_attendees << Attendee.new(record)
    end
  end
end
