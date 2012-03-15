require 'commands'

describe "run" do
  before(:each) do
    @command = Commands.new
  end

  it "is case-insensitive" do
    input = mock(String)
    args = mock(String)
    args_array = mock(Array)

    input.should_receive(:downcase).and_return(args)
    args.should_receive(:split).and_return(args_array)
    args_array.should_receive(:shift)
    args_array.should_receive(:join).with(" ")
    @command.run(input)
  end
end

