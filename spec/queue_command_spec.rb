require 'attendee'
require 'queue'
require 'queue_command'
require 'printer'

describe QueueCommand, "(print|print by|save to)" do
  before(:each) do
    @queue = mock(Queue)
    @printer = mock(Printer)
    @command = QueueCommand.new(@queue, @printer)
  end

  it "should respond to queue methods" do
    @queue.stub(:responds_to?).with("count").and_return(true)
    @queue.should_receive(:count)
    @command.run("count")
  end
  
  it "should print by attribute" do
    @queue.stub(:responds_to?).with("print").and_return(false)
    @printer.should_receive(:print_by).with("last_name")
    @command.run("print by last_name")
  end

  it "should save to file"  do
    @queue.stub(:responds_to?).with("save").and_return(false)
    @printer.should_receive(:save_to).with("testfile")
    @command.run("save to testfile")
  end

  it "accepts supported print attributes" do
    @command.is_valid_query?("print").should == true
    @command.is_valid_query?("print by regdate").should == true
    @command.is_valid_query?("print by first_name").should == true
    @command.is_valid_query?("print by last_name").should == true
    @command.is_valid_query?("print by homephone").should == true
    @command.is_valid_query?("print by email_address").should == true
    @command.is_valid_query?("print by street").should == true
    @command.is_valid_query?("print by state").should == true
    @command.is_valid_query?("print by city").should == true
    @command.is_valid_query?("print by zipcode").should == true
  end

  it "does not accept unsupported print attributes" do
    @command.is_valid_query?("prints hi").should == false
    @command.is_valid_query?("print hi").should == false
  end
end
