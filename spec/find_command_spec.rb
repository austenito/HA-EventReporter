require 'attendee'
require 'find_command'

describe FindCommand, "#find(single query)" do
  before(:each) do
    @attendee = mock(Attendee)
    @attendee.stub(:first_name).and_return("Jeff")
    @attendee2 = mock(Attendee)
    @attendee2.stub(:first_name).and_return("Matt")
    @attendee3 = mock(Attendee)
    @attendee3.stub(:first_name).and_return("Jeff")
    @attendees = [@attendee, @attendee2, @attendee3]
  end

  it "finds attendees" do
   @attendee.should_receive(:first_name)
   @attendee2.should_receive(:first_name)
   @attendee3.should_receive(:first_name)
   result = FindCommand.find("first_name Jeff", @attendees)
  
   result.length.should == 2
   result.include?(@attendee).should == true
   result.include?(@attendee3).should == true
  end

  it "finds no attendees" do
   result = FindCommand.find("first_name Austen", @attendees)
   result.length.should == 0
  end
end
