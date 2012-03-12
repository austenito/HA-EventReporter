require '../phone_number'

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
end

  #def test_clean_zipcodes
    #manager = Cleaner
    #assert_equal "96789", manager.clean_zipcodes("96789")
    #assert_equal "00009", manager.clean_zipcodes("9")
    #assert_equal "00089", manager.clean_zipcodes("89")
    #assert_equal "00789", manager.clean_zipcodes("789")
    #assert_equal "06789", manager.clean_zipcodes("6789")

    #assert_equal "00000", manager.clean_zipcodes("967899")
    #assert_equal "00000", manager.clean_zipcodes(nil)
    #assert_equal "00000", manager.clean_zipcodes("a969")
    #assert_equal "00000", manager.clean_zipcodes("967a9")
    #assert_equal "00000", manager.clean_zipcodes("a967899")
  #end
#end
