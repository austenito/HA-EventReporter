require 'attendee_queue'
require 'result'

# The command used to load csv files into the system
class Loader
  DEFAULT_FILE = File.dirname(__FILE__) + "/event_attendees.csv"
  attr_reader :attendee_queue

  def initialize(attendee_queue = AttendeeQueue.new)
    @attendee_queue = attendee_queue
  end

  def load(filename)
    filename = DEFAULT_FILE if filename.length == 0
    if Validator.valid?("load", filename)
      if File.exists?(filename)
        @attendee_queue.clear
        @attendee_queue.all_attendees = (build(filename))
        Result.ok(filename)
      else
        Result.fail(:invalid_file);
      end
    end
  end

  private

  def build(filename)
    attendees = []
    file = CSV.open(filename, {:headers => true,
                    :header_converters => :symbol})

    attendees = []
    file.each do |line|
      record = line.to_hash
      attendees << Attendee.new(record)
    end
    attendees
  end
end
