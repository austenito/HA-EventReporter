require 'phone_number'

describe PhoneNumber, "#clean_number" do
  it "removes illegal chars" do
    PhoneNumber.new("510-517-3000").phone_number.should eq("5105173000")
    PhoneNumber.new("5105173000").phone_number.should eq("5105173000")
    PhoneNumber.new("510.517.3000").phone_number.should eq("5105173000")
    PhoneNumber.new("(510)517-3000").phone_number.should eq("5105173000")
    PhoneNumber.new("(510) 517-3000").phone_number.should eq("5105173000")
    PhoneNumber.new("510 517 3000").phone_number.should eq("5105173000")
    PhoneNumber.new("1510 517 3000").phone_number.should eq("5105173000")
    PhoneNumber.new("15105173000").phone_number.should eq("5105173000")
  end

  it "returns invalid phone number" do
    PhoneNumber.new("5105173000aldfjadkf").phone_number.should eq("0000000000")
    PhoneNumber.new("151051730001").phone_number.should eq("0000000000")
    PhoneNumber.new("hi0000").phone_number.should eq("0000000000")
  end

  it "returns int phone number" do
    PhoneNumber.new("8197777777").to_i.should == 8197777777
  end
end
