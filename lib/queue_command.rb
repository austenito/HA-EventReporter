require "printer"

class QueueCommand
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
      puts "#{action}_#{action_modifier}" + " #{attribute}"
      printer.send("#{action}_#{action_modifier}", attribute)
    end
  end
end
