require 'attendee_queue'
require 'find'
require 'attendee'
require 'validator'

describe "find matches" do
  before(:each) do
    @attendee = mock(Attendee)
    @queue = mock(AttendeeQueue)
    @command = Find.new(@queue)
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
    @queue = mock(AttendeeQueue)
    @command = Find.new(@queue)
  end

  it "clears queue" do
    @command.stub(:find_matches).and_return([])
    @queue.should_receive(:add)
    @command.find("first_name Austen")
  end

  it "handles compound query" do
    args = mock(String)
    clause = mock(String)
    args.should_receive(:split).with("and").and_return([clause])

    Validator.stub(:valid?).and_return(true)
    clause.should_receive(:strip).and_return(clause)
    clause.should_receive(:split).and_return(["first_name", "austen"])

    values = Array.new
    @command.stub!(:find_matches).and_return(values)
    @queue.should_receive(:add).with(values)
    @command.find(args)
  end
end
