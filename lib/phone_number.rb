class PhoneNumber
  INVALID_PHONE_NUM  = "0000000000"
  attr_accessor :phone_number

  def initialize(phone_number) 
    phone_number = phone_number.delete('.()  -')
    if phone_number.length == 11 && phone_number[0] == "1" 
     phone_number = phone_number[1..-1]
    elsif phone_number.length != 10
      phone_number = INVALID_PHONE_NUM
    end
    self.phone_number = phone_number
  end
end
