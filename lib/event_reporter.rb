class EventReporter 

  #def output_data(filename)
    #output = CSV.open(filename, "w")
    #@file.each do |line|
      #if @file.lineno == 2
        #output << line.headers
      #end
      #line[:homephone] = clean_phone_numbers(line[:homephone])
      #line[:zipcode] = clean_zipcodes(line[:zipcode])
      #output << line
    #end
  #end

  def run
    #@filename = filename
    @filename = "eventattendees.csv"
    if @filename != ""
      @file = CSV.open(@filename, {:headers => true, :header_converters => :symbol})
      number = clean_phone_numbers(line[:homephone])
      zipcode = clean_zipcodes(line[:zipcode])
    end

    #printf "Enter file to load (Empty file loads eventattendees.csv): "
    #command = gets

    while command != "q"
      printf "Enter command: "
      command = gets
      printf command
    end
  end
end

r = EventReporter.new
r.run
