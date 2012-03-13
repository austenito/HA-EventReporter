require 'attendee'

describe Attendee, "open struct" do
  it "creates accessors" do
    attendee = Attendee.new(name: "hi")
    attendee.name.should eq("hi")
  end
end
