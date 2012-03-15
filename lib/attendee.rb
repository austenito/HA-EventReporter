require 'ostruct'
require 'phone_number'
require 'zip_code'

# The object containing attendee data. The methods on this class are set using
# the keys from the specified hash
class Attendee < OpenStruct

  # Accepts a hash of arguments used to generate the methods for this attendee
  #
  # ==== Examples
  # initialize({first_name: "austen"} => attendee.first_name
  def initialize(args)
    super
    self.homephone = PhoneNumber.new(self.homephone)
    self.zipcode= ZipCode.new(self.zipcode)
  end
end
