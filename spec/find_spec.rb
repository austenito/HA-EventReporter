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
    attendees = mock(Array)
    @command.stub(:find_matches).and_return(attendees)
    @queue.should_receive(:all_attendees).and_return([])
    @queue.should_receive(:add).with(attendees)
    @command.find("first_name Austen")
  end
end

describe "Find.map_find" do
  it "build params" do
    Find.map_find("last_name austen").should == {"last_name" => "austen"}
    Find.map_find("last_name austen and state hi").should == 
      {"last_name" => "austen", "state" => "hi"}
    Find.map_find("foo austen and state hi").should == {}
    Find.map_find("foo austen").should == {}
  end
end
