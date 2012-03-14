require 'validator'

describe Validator, "#is_value?" do
  it "rejects invalid commands" do
    Validator.is_valid?("touch", "regdate hi").should == false
    Validator.is_valid?("", "").should == false
    Validator.is_valid?(nil, nil).should == false
  end

  it "accepts supported find attributes" do
    Validator.is_valid?("find", "regdate hi").should == true
    Validator.is_valid?("find", "first_name hi").should == true
    Validator.is_valid?("find", "last_name hi").should == true
    Validator.is_valid?("find", "homephone 123123").should == true
    Validator.is_valid?("find", "email_address 123123").should == true
    Validator.is_valid?("find", "homephone test@test.com").should == true
    Validator.is_valid?("find", "street 1220 Ohio").should == true
    Validator.is_valid?("find", "street 1220 Ohio St.").should == true
    Validator.is_valid?("find", "state HI").should == true
    Validator.is_valid?("find", "city Honolulu").should == true
    Validator.is_valid?("find", "zipcode 96819").should == true
  end

  it "does not accept unsupported find attributes" do
    Validator.is_valid?("find", "regdates hi").should == false
    Validator.is_valid?("find", "find").should == false
    Validator.is_valid?("find", "regdate").should == false
  end

  it "accepts supported print attributes" do
    Validator.is_valid?("queue", "print").should == true
    Validator.is_valid?("queue", "print by regdate").should == true
    Validator.is_valid?("queue", "print by first_name").should == true
    Validator.is_valid?("queue", "print by last_name").should == true
    Validator.is_valid?("queue", "print by homephone").should == true
    Validator.is_valid?("queue", "print by email_address").should == true
    Validator.is_valid?("queue", "print by street").should == true
    Validator.is_valid?("queue", "print by state").should == true
    Validator.is_valid?("queue", "print by city").should == true
    Validator.is_valid?("queue", "print by zipcode").should == true
  end

  it "queue", "does not accept unsupported print attributes" do
    Validator.is_valid?("queue", "prints hi").should == false
    Validator.is_valid?("queue", "print hi").should == false
  end

  it "queue", "accepts supported save attributes" do
    Validator.is_valid?("queue", "save to file").should == true
    Validator.is_valid?("queue", "save to file.txt").should == true
  end

  it "queue", "does not accept save attributes" do
    Validator.is_valid?("queue", "save file").should == false  
    Validator.is_valid?("queue", "save to file.txt hi").should == false 
  end

  it "queue", "does handle count" do
    Validator.is_valid?("queue", "count").should == true 
    Validator.is_valid?("queue", "counts").should == false
  end

  it "queue", "does handle clear" do
    Validator.is_valid?("queue", "clear").should == true 
    Validator.is_valid?("queue", "clears").should == false 
  end
end
