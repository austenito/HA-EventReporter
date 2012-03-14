require 'attendee'
require 'queue'
require 'queue_command'
require 'printer'

describe QueueCommand, "(print|print by|save to)" do
  before(:each) do
    @queue = mock(Queue)
    @printer = mock(Printer)
    @command = QueueCommand.new(@queue, @printer)
    @attendees = mock(Array)
    @queue.stub(:attendees).and_return(@attendees)
  end

  it "should respond to queue methods" do
    @queue.stub(:responds_to?).with("count").and_return(true)
    @queue.should_receive(:count)
    @command.run("count")
  end
  
  it "should print by attribute" do
    @queue.stub(:responds_to?).with("print").and_return(false)
    @queue.should_receive(:sort_by).with("last_name")
    @printer.should_receive(:print).with(@attendees)
    @command.run("print by last_name")
  end

  it "should save to file"  do
    @printer.should_receive(:save_to).with(@attendees, "testfile")
    @command.run("save to testfile")
  end
end
