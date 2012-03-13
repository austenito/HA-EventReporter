require 'ostruct'
require 'phone_number'
require 'zip_code'

class Attendee < OpenStruct
  def initialize(args)
    super 
    self.homephone = PhoneNumber.new(self.homephone)
    self.zipcode= ZipCode.new(self.zipcode)
  end
end
