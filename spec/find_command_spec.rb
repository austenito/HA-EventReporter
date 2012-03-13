require 'attendee'
require 'find_command'

describe FindCommand, "#find <attribute> <criteria>" do
  before(:each) do
    @attendee = mock(Attendee)
    @attendee.stub(:first_name).and_return("Jeff")
    @attendee2 = mock(Attendee)
    @attendee2.stub(:first_name).and_return("Matt")
    @attendee3 = mock(Attendee)
    @attendee3.stub(:first_name).and_return("Jeff")
    @attendees = [@attendee, @attendee2, @attendee3]

    @command = FindCommand.new
  end

  it "finds attendees" do
   @attendee.should_receive(:first_name)
   @attendee2.should_receive(:first_name)
   @attendee3.should_receive(:first_name)
   result = @command.find("first_name Jeff", @attendees)
  
   result.length.should == 2
   result.include?(@attendee).should == true
   result.include?(@attendee3).should == true
  end

  it "finds no attendees" do
   result = @command.find("first_name Austen", @attendees)
   result.length.should == 0
  end
  
  it "finds address with spaces" do
    address = "1234 Roar St."
    other_attendee = mock(Attendee)
    other_attendee.stub(:street).and_return(address)
    other_attendees = [other_attendee]

    other_attendee.should_receive(:street)
    result = @command.find("street #{address}", other_attendees)

    result.length.should == 1
    result.include?(other_attendee).should == true
  end

  it "accepts supported attributes" do
    @command.is_valid_query?("regdate hi").should == true
    @command.is_valid_query?("first_name hi").should == true
    @command.is_valid_query?("last_name hi").should == true
    @command.is_valid_query?("homephone 123123").should == true
    @command.is_valid_query?("email_address 123123").should == true
    @command.is_valid_query?("homephone test@test.com").should == true
    @command.is_valid_query?("street 1220 Ohio").should == true
    @command.is_valid_query?("street 1220 Ohio St.").should == true
    @command.is_valid_query?("state HI").should == true
    @command.is_valid_query?("city Honolulu").should == true
    @command.is_valid_query?("zipcode 96819").should == true
  end

  it "does not accept unsupported attributes" do
    @command.is_valid_query?("regdates hi").should == false
    @command.is_valid_query?("find").should == false
    @command.is_valid_query?("regdate").should == false
  end
end
