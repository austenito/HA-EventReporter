require 'attendee_queue'
require 'queue'
require 'printer'
require 'validator'

describe "queue <print>|<print by>|<save to>" do
  before(:each) do
    @queue = mock(AttendeeQueue)
    @printer = mock(Printer)
    @command = Queue.new(@queue, @printer)
    @attendees = mock(Array)
    @queue.stub(:attendees).and_return(@attendees)
  end

  it "to queue methods" do
    @queue.stub(:responds_to?).with("count")
    @queue.should_receive(:count)
    @command.queue("count")
  end

  it "should print by attribute" do
    @queue.stub(:responds_to?).with("print").and_return(false)
    @queue.should_receive(:sort_by).with("last_name")
    @queue.should_receive(:filtered_attendees).and_return(@attendees)
    @printer.should_receive(:print).with(@attendees)
    @command.queue("print by last_name")
  end

  it "should save to file"  do
    @queue.should_receive(:filtered_attendees).and_return(@attendees)
    @printer.should_receive(:save_to).with(@attendees, "testfile")
    @command.queue("save to testfile")
  end
end

describe "subtract" do
  before(:each) do
    @queue = mock(AttendeeQueue)
    @command = Queue.new(@queue)
    @attendees = mock(Array)
  end

  it "from from queue" do
    results = mock(Array)
    attendee = mock(Attendee)
    Validator.stub(:valid?).and_return(true)

    @command.stub(:query_params).and_return(results)
    results.should_receive(:inject).and_yield(0, attendee).and_return(0)
    @queue.should_receive(:remove).with(attendee)

    @command.subtract(mock(String))
  end
end

describe "add" do
  before(:each) do
    @queue = mock(AttendeeQueue)
    @command = Queue.new(@queue)
    @attendees = mock(Array)
  end

  it "add to queue" do
    results = mock(Array)
    attendee = mock(Attendee)
    Validator.stub(:valid?).and_return(true)

    @command.stub(:query_params).and_return(results)
    results.should_receive(:inject).and_yield(0, attendee).and_return(0)
    @queue.should_receive(:append).with(attendee)

    @command.add(mock(String))
  end
end
