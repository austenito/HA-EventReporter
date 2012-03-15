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
    @attendees.should_receive(:+)
    @queue.add(Array.new)
  end

  it "sorts by string name" do
    attendee = mock(Attendee)
    attendee.should_receive("attribute")
    @attendees.should_receive(:sort_by).and_yield(attendee)
    @queue.sort_by("attribute")
  end

  it "sorts by date" do
    attendee = mock(Attendee)
    value = mock(String)
    @attendees.should_receive(:sort_by).and_yield(attendee)
    attendee.should_receive("regdate").and_return(value)

    DateTime.should_receive(:strptime).with(value, "%m/%d/%Y %H:%M")
    @queue.sort_by("regdate")
  end

  it "sorts by phone number" do
    attendee = mock(Attendee)
    value = mock(String)

    @attendees.should_receive(:sort_by).and_yield(attendee)
    attendee.should_receive("homephone").and_return(value)
    value.should_receive(:to_i)
    @queue.sort_by("homephone")
  end

  it "sorts by zipcode" do
    attendee = mock(Attendee)
    value = mock(String)

    @attendees.should_receive(:sort_by).and_yield(attendee)
    attendee.should_receive("zipcode").and_return(value)
    value.should_receive(:to_i)
    @queue.sort_by("zipcode")
  end

  it "deletes attendees" do
    attendee = mock(Attendee)
    @attendees.should_receive(:delete).with(attendee)

    @queue.remove(attendee)
  end

  it "appends attendees" do
    attendee = mock(Attendee)
    @attendees.should_receive(:clear).never
    @attendees.should_receive(:<<).with(attendee)
    @queue.append(attendee)
  end
end
