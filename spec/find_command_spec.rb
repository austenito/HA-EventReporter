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

  it "accepts supported attributes" do
    @command.is_valid_query?("find regdate hi").should == true
    @command.is_valid_query?("find first_name hi").should == true
    @command.is_valid_query?("find last_name hi").should == true
    @command.is_valid_query?("find homephone 123123").should == true
    @command.is_valid_query?("find email_address 123123").should == true
    @command.is_valid_query?("find homephone test@test.com").should == true
    @command.is_valid_query?("find street 1220 Ohio").should == true
    @command.is_valid_query?("find state HI").should == true
    @command.is_valid_query?("find city Honolulu").should == true
    @command.is_valid_query?("find zipcode 96819").should == true
  end

  it "does not accept unsupported attributes" do
    @command.is_valid_query?("find regdates hi").should == false
    @command.is_valid_query?("find").should == false
    @command.is_valid_query?("find regdate").should == false
  end
end
