class LoadCommand
  attr_reader :filename

  def initialize
  end

  def load(filename="eventattendees.csv")
    @filename = filename
  end

end
