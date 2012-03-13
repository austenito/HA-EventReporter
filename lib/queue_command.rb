require "printer"

class QueueCommand
  VALID_ATTR = "regdate|first_name|last_name|email_address|homephone|" +
                "street|city|state|zipcode"
  attr_reader :queue, :printer

  def initialize(queue = Queue.new, printer = Printer.new)
    @queue = queue
    @printer = printer
  end

  def run(query)
    commands = query.split
    action = commands[0]
    if queue.responds_to?(action)
      return queue.send(action)
    else
      action_modifier = commands[1]
      attribute = commands[2]
      printer.send("#{action}_#{action_modifier}", attribute)
    end
  end

  def is_valid_query?(query)
    (query =~ /print( by (#{VALID_ATTR}))?$/) == 0
  end
end
