class Cleaner
  INVALID_PHONE_NUM  = "0000000000"
  INVALID_ZIPCODE = "00000"

  def self.clean_phone_numbers(number)
    number = number.delete('.()  -')
    if number.length == 11 && number[0] == "1" 
      number = number[1..-1]
    elsif number.length != 10
      number = INVALID_PHONE_NUM
    end
    return number 
  end

  def self.clean_zipcodes(zipcode)
    if zipcode.nil? || zipcode.length > 5
      zipcode = INVALID_ZIPCODE
    elsif /\d*\D+\d*/.match(zipcode)
      zipcode = INVALID_ZIPCODE
    elsif zipcode.length < 5
      diff = 5 - zipcode.length
      diff.times do |i|
        zipcode = zipcode.insert(i, '0')  
      end
    end
    return zipcode
  end
end
