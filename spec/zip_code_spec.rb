require 'zip_code'

describe ZipCode, "#clean_zipcode" do
  it "prepends zeroes" do 
    ZipCode.new("96789").zipcode.should eq("96789")
    ZipCode.new("9").zipcode.should eq("00009")
    ZipCode.new("89").zipcode.should eq("00089")
    ZipCode.new("789").zipcode.should eq("00789")
    ZipCode.new("6789").zipcode.should eq("06789")
  end

  it "returns default zipcode" do
    ZipCode.new("967899").zipcode.should eq("00000")
    ZipCode.new(nil).zipcode.should eq("00000")
    ZipCode.new("a969").zipcode.should eq("00000")
    ZipCode.new("967a9").zipcode.should eq("00000")
    ZipCode.new("a967899").zipcode.should eq("00000")
  end

  it "returns int zipcode" do
    ZipCode.new("67899").to_i.should == 67899
  end

  it "returns string zipcode" do
    ZipCode.new("67899").to_s.should == "67899"
  end
end
