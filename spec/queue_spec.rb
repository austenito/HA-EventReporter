require 'attendee'
require 'queue'

describe Queue do
  before(:each) do
    @attendees = mock(Array)
    @queue = Queue.new(@attendees)
  end

  it "returns queue count" do
    @attendees.should_receive(:length)
    @queue.count
  end

  it "clears queue" do
    @attendees.should_receive(:clear)
    @queue.clear
  end

  it "clears before adding new attendees" do
    @attendees.should_receive(:clear)
    @attendees.should_receive(:<<)
    @queue.add(Array.new)
  end
end
