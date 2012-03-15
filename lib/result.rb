# The object returned from executed commands
class Result
  attr_reader :value, :success

  def initialize(value=nil, success = true)
    @value= value
    @success = success
  end

  def success?
    success
  end

  def self.fail(value = nil)
    Result.new(value, false)
  end

  def self.ok(value = nil)
    Result.new(value)
  end
end
