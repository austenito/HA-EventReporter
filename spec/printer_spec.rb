require 'printer'

describe Printer do
  before(:each) do
    @printer = Printer.new
    @attendees = mock(Array)
    @attendee = mock(Attendee)
    @attendee2 = mock(Attendee)
  end

  it "should save to file" do
    csv = mock(CSV)
    hash_dump = mock(Hash)
    keys = mock(Array)
    values = mock(Array)

    CSV.should_receive(:open).with("output", "w").and_return(csv)
    csv.should_receive(:close)
    csv.should_receive(:<<).once.with(keys)
    csv.should_receive(:<<).exactly(2).times.with(values)

    @attendees.should_receive(:each).and_yield(@attendee).and_yield(@attendee2)
    @attendee.should_receive(:marshal_dump).and_return(hash_dump)
    @attendee2.should_receive(:marshal_dump).and_return(hash_dump)
    hash_dump.should_receive(:keys).and_return(keys)
    hash_dump.should_receive(:values).exactly(2).times.and_return(values)

    @printer.save_to(@attendees, "output")
  end
end
