require 'validator'

describe Validator, "#is_value?" do
  it "rejects invalid commands" do
    Validator.valid?("touch", "regdate hi").should == false
    Validator.valid?("", "").should == false
    Validator.valid?(nil, nil).should == false
  end

  it "accepts supported find attributes" do
    Validator.valid?("find", "regdate hi").should == true
    Validator.valid?("find", "first_name hi").should == true
    Validator.valid?("find", "last_name hi").should == true
    Validator.valid?("find", "homephone 123123").should == true
    Validator.valid?("find", "email_address 123123").should == true
    Validator.valid?("find", "homephone test@test.com").should == true
    Validator.valid?("find", "street 1220 Ohio").should == true
    Validator.valid?("find", "street 1220 Ohio St.").should == true
    Validator.valid?("find", "state HI").should == true
    Validator.valid?("find", "city Honolulu").should == true
    Validator.valid?("find", "zipcode 96819").should == true
  end

  it "accepts supported subtract attributes" do
    Validator.valid?("subtract","find regdate hi").should == true
    Validator.valid?("subtract","find first_name hi").should == true
    Validator.valid?("subtract","find last_name hi").should == true
    Validator.valid?("subtract","find homephone 123123").should == true
    Validator.valid?("subtract","find email_address 123123").should == true
    Validator.valid?("subtract","find homephone test@test.com").should == true
    Validator.valid?("subtract","find street 1220 Ohio").should == true
    Validator.valid?("subtract","find street 1220 Ohio St.").should == true
    Validator.valid?("subtract","find state HI").should == true
    Validator.valid?("subtract","find city Honolulu").should == true
    Validator.valid?("subtract","find zipcode 96819").should == true
  end

  it "accepts supported subtract attributes" do
    Validator.valid?("add","find regdate hi").should == true
    Validator.valid?("add","find first_name hi").should == true
    Validator.valid?("add","find last_name hi").should == true
    Validator.valid?("add","find homephone 123123").should == true
    Validator.valid?("add","find email_address 123123").should == true
    Validator.valid?("add","find homephone test@test.com").should == true
    Validator.valid?("add","find street 1220 Ohio").should == true
    Validator.valid?("add","find street 1220 Ohio St.").should == true
    Validator.valid?("add","find state HI").should == true
    Validator.valid?("add","find city Honolulu").should == true
    Validator.valid?("add","find zipcode 96819").should == true
  end

  it "does not accept unsupported find attributes" do
    Validator.valid?("find", "regdates hi").should == false
    Validator.valid?("find", "find").should == false
    Validator.valid?("find", "regdate").should == false
  end

  it "accepts supported print attributes" do
    Validator.valid?("queue", "print").should == true
    Validator.valid?("queue", "print by regdate").should == true
    Validator.valid?("queue", "print by first_name").should == true
    Validator.valid?("queue", "print by last_name").should == true
    Validator.valid?("queue", "print by homephone").should == true
    Validator.valid?("queue", "print by email_address").should == true
    Validator.valid?("queue", "print by street").should == true
    Validator.valid?("queue", "print by state").should == true
    Validator.valid?("queue", "print by city").should == true
    Validator.valid?("queue", "print by zipcode").should == true
  end

  it "does not accept unsupported print attributes" do
    Validator.valid?("queue", "prints hi").should == false
    Validator.valid?("queue", "print hi").should == false
  end

  it "accepts supported save attributes" do
    Validator.valid?("queue", "save to file").should == true
    Validator.valid?("queue", "save to file.txt").should == true
    Validator.valid?("queue", "save to file.txt hi").should == true 
    Validator.valid?("queue", "save to /Users/austen/file.txt").should == true
  end

  it "does not accept save attributes" do
    Validator.valid?("queue", "save file").should == false  
  end

  it "does handle count" do
    Validator.valid?("queue", "count").should == true 
    Validator.valid?("queue", "counts").should == false
  end

  it "does handle clear" do
    Validator.valid?("queue", "clear").should == true 
    Validator.valid?("queue", "clears").should == false 
  end

  it "loads any filename" do
    Validator.valid?("load", "clears").should == true 
    Validator.valid?("load", "C:\\Windows Sucks").should == true 
    Validator.valid?("load", "/home/austen/omg").should == true 
  end
end
