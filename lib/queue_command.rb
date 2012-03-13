require "queue"
require "printer"

class QueueCommand
  ATTR = "regdate|first_name|last_name|email_address|homephone|" +
                "street|city|state|zipcode"
  attr_reader :queue, :printer

  def initialize(queue = Queue.new, printer = Printer.new)
    @queue = queue
    @printer = printer
  end

  def run(query)
    commands = query.split
    action = commands[0]

    case action
    when "print"
      if commands.length == 3
        queue.sort_by(commands.last)
      end
      printer.print(queue.attendees)
    when "save"
      printer.save_to(queue.attendees, commands.last)
    else
      queue.send(action)
    end
  end

  def is_valid?(query)
    (query =~ /count$|clear$|print( by (#{ATTR}))?$|save to \w+(.\w+)?$/) == 0
  end
end
