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
   result = @command.find(@attendees, "first_name Jeff")
  
   result.length.should == 2
   result.include?(@attendee).should == true
   result.include?(@attendee3).should == true
  end

  it "finds zipcode" do
    zipcode = ZipCode.new("96789")
    other_attendee = mock(Attendee)
    other_attendee.stub(:zipcode).and_return(zipcode)
    other_attendees = [other_attendee]
    result = @command.find(other_attendees, "zipcode 96789")

    result.length.should == 1
    result.include?(other_attendee).should == true
  end

  it "finds homephone" do
    home_phone = PhoneNumber.new("8082301111")
    other_attendee = mock(Attendee)
    other_attendee.stub(:homephone).and_return(home_phone)
    other_attendees = [other_attendee]
    result = @command.find(other_attendees, "homephone 8082301111")

    result.length.should == 1
    result.include?(other_attendee).should == true
  end

  it "finds no attendees" do
   result = @command.find(@attendees, "first_name Austen")
   result.length.should == 0
  end
  
  it "finds address with spaces" do
    address = "1234 Roar St."
    other_attendee = mock(Attendee)
    other_attendee.stub(:street).and_return(address)
    other_attendees = [other_attendee]

    other_attendee.should_receive(:street)
    result = @command.find(other_attendees, "street #{address}")

    result.length.should == 1
    result.include?(other_attendee).should == true
  end
end
