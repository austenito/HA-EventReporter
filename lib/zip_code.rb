class ZipCode
  attr_accessor :zipcode
  INVALID_ZIPCODE = "00000"

  def initialize(zipcode)
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
    self.zipcode = zipcode
  end

  def to_i
    zipcode.to_i
  end

  def to_s
    zipcode.to_s
  end
end
