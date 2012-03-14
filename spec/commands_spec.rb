require 'attendee'
require 'commands'
require 'queue'
require 'printer'

describe "run" do
  before(:each) do
    @command = Commands.new
  end

  it "is case-insensitive" do
    input = mock(String)
    args = mock(String)
    args_array = mock(Array)
  
    input.should_receive(:downcase).and_return(args)
    args.should_receive(:split).and_return(args_array)
    args_array.should_receive(:shift)
    args_array.should_receive(:join).with(" ")
    @command.run(input)
  end
end

describe "find matches" do
  before(:each) do
    @attendee = mock(Attendee)
    @command = Commands.new(@queue)
    @attendees = mock(Array)
    @params = mock(Hash) 
  end

  it "finds attendees" do
    first_name = mock(String)
    next_first_name = mock(String)

    @params.should_receive(:all?).and_yield("first_name", "jeff")
    @attendee.should_receive(:send).and_return(first_name)
    first_name.should_receive(:to_s).and_return(next_first_name)
    next_first_name.should_receive(:downcase).and_return("jeff")

    @command.find_matches([@attendee], @params)
  end
end

describe "find" do
  before(:each) do
    @queue = Queue.new
    @command = Commands.new(@queue)
  end

  it "clears queue" do
    @queue.should_receive(:clear) 
    @queue.should_receive(:add) 
    @command.find("first_name Austen")
  end

  it "handles compound query" do
    args = mock(String)
    clause = mock(String)
    args.should_receive(:split).with("and").and_return([clause])

    Validator.stub(:is_valid?).and_return(true)
    clause.should_receive(:strip).and_return(clause)
    clause.should_receive(:split).and_return(["first_name", "austen"])

    values = Array.new
    @command.stub!(:find_matches).and_return(values)
    @queue.should_receive(:add).with(values)
    @command.find(args)
  end
end

describe "find <attribute> <criteria> and <attribute> <criteria>" do
end

describe "queue <print>|<print by>|<save to>" do
  before(:each) do
    @queue = mock(Queue)
    @printer = mock(Printer)
    @command = Commands.new(@queue, @printer)
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
    @printer.should_receive(:print).with(@attendees)
    @command.queue("print by last_name")
  end

  it "should save to file"  do
    @printer.should_receive(:save_to).with(@attendees, "testfile")
    @command.queue("save to testfile")
  end
end
