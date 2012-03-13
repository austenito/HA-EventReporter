require 'attendee'
require 'queue'
require 'queue_command'
require 'printer'

describe QueueCommand, "(print|print by|save to)" do
  before(:each) do
    @queue = mock(Queue)
    @printer = mock(Printer)
    @command = QueueCommand.new(@queue, @printer)
    @attendees = mock(Array)
    @queue.stub(:attendees).and_return(@attendees)
  end

  it "should respond to queue methods" do
    @queue.stub(:responds_to?).with("count").and_return(true)
    @queue.should_receive(:count)
    @command.run("count")
  end
  
  it "should print by attribute" do
    @queue.stub(:responds_to?).with("print").and_return(false)
    @queue.should_receive(:sort_by).with("last_name")
    @printer.should_receive(:print).with(@attendees)
    @command.run("print by last_name")
  end

  it "should save to file"  do
    @printer.should_receive(:save_to).with(@attendees, "testfile")
    @command.run("save to testfile")
  end

  it "accepts supported print attributes" do
    @command.is_valid?("print").should == true
    @command.is_valid?("print by regdate").should == true
    @command.is_valid?("print by first_name").should == true
    @command.is_valid?("print by last_name").should == true
    @command.is_valid?("print by homephone").should == true
    @command.is_valid?("print by email_address").should == true
    @command.is_valid?("print by street").should == true
    @command.is_valid?("print by state").should == true
    @command.is_valid?("print by city").should == true
    @command.is_valid?("print by zipcode").should == true
  end

  it "does not accept unsupported print attributes" do
    @command.is_valid?("prints hi").should == false
    @command.is_valid?("print hi").should == false
  end

  it "accepts supported save attributes" do
    @command.is_valid?("save to file").should == true
    @command.is_valid?("save to file.txt").should == true
  end

  it "does not accept save attributes" do
    @command.is_valid?("save file").should == false  
    @command.is_valid?("save to file.txt hi").should == false 
  end

  it "does accept methods" do
    @command.is_valid?("count").should == true 
    @command.is_valid?("counts").should == false
    @command.is_valid?("clear").should == true 
    @command.is_valid?("clears").should == false 
  end
end
