require 'attendee'
require 'commands'
require 'queue'
require 'printer'

describe "run" do
  before(:each) do
    @command = Commands.new
  end

  it "is case-insensitive" do
    input = mock(String)
    args = mock(String)
    args_array = mock(Array)
  
    input.should_receive(:downcase).and_return(args)
    args.should_receive(:split).and_return(args_array)
    args_array.should_receive(:shift)
    args_array.should_receive(:join).with(" ")
    @command.run(input)
  end
end

describe "find <attribute> <criteria>" do
  before(:each) do
    @attendee = mock(Attendee)
    @attendee.stub(:first_name).and_return("Jeff")
    @queue = mock(Queue)
    @command = Commands.new(@queue)
  end

  it "finds attendees" do
    attendee2 = mock(Attendee)
    attendee2.stub(:first_name).and_return("Matt")
    attendee3 = mock(Attendee)
    attendee3.stub(:first_name).and_return("Jeff")

    @attendee.should_receive(:first_name)
    attendee2.should_receive(:first_name)
    attendee3.should_receive(:first_name)
    @command.all_attendees = [@attendee, attendee2, attendee3]

    @queue.should_receive(:clear) 
    @queue.should_receive(:add) 
    @command.find("first_name Jeff")
  end

  it "finds zipcode" do
    @queue.should_receive(:clear) 
    @queue.should_receive(:add) 
    zipcode = ZipCode.new("96789")
    other_attendee = mock(Attendee)
    other_attendee.stub(:zipcode).and_return(zipcode)
    other_attendees = [other_attendee]
    @command.all_attendees = other_attendees
    @command.find("zipcode 96789")
  end

  it "finds homephone" do
    @queue.should_receive(:clear) 
    @queue.should_receive(:add) 
    home_phone = PhoneNumber.new("8082301111")
    other_attendee = mock(Attendee)
    other_attendee.stub(:homephone).and_return(home_phone)
    other_attendees = [other_attendee]
    @command.all_attendees = other_attendees
    @command.find("homephone 8082301111")
  end

  it "finds no attendees" do
    @queue.should_receive(:clear) 
    @queue.should_receive(:add) 
    @command.find("first_name Austen")
  end

  it "finds address with spaces" do
    @queue.should_receive(:clear) 
    @queue.should_receive(:add) 

    address = "1234 Roar St."
    other_attendee = mock(Attendee)
    other_attendee.stub(:street).and_return(address)
    other_attendees = [other_attendee]
    other_attendee.should_receive(:street)
    
    @command.all_attendees = other_attendees
    @command.find("street #{address}")
  end
end

describe "queue <print>|<print by>|<save to>" do
  before(:each) do
    @queue = mock(Queue)
    @printer = mock(Printer)
    @command = Commands.new(@queue, @printer)
    @attendees = mock(Array)
    @queue.stub(:attendees).and_return(@attendees)
  end

  it "to queue methods" do
    @queue.stub(:responds_to?).with("count")
    @queue.should_receive(:count)
    @command.queue("count")
  end

  it "should print by attribute" do
    @queue.stub(:responds_to?).with("print").and_return(false)
    @queue.should_receive(:sort_by).with("last_name")
    @printer.should_receive(:print).with(@attendees)
    @command.queue("print by last_name")
  end

  it "should save to file"  do
    @printer.should_receive(:save_to).with(@attendees, "testfile")
    @command.queue("save to testfile")
  end
end
