require 'attendee'
require 'queue'
require 'queue_command'
require 'printer'

describe QueueCommand do
  before(:each) do
    @queue = mock(Queue)
    @printer = mock(Printer)
    @command = QueueCommand.new(@queue, @printer)
  end

  it "should respond to queue methods" do
    @queue.stub(:responds_to?).with("count").and_return(true)
    @queue.should_receive(:count)
    @command.run("count")
  end
  
  it "should print by attribute" do
    @queue.stub(:responds_to?).with("print").and_return(false)
    @printer.should_receive(:print_by).with("last_name")
    @command.run("print by last_name")
  end

  it "should save to file"  do
    @queue.stub(:responds_to?).with("save").and_return(false)
    @printer.should_receive(:save_to).with("testfile")
    @command.run("save to testfile")
  end
end
