class Logger

  attr_reader :verbose , :output
  def initialize(verbose = nil  , output = nil )
     @verbose = verbose
	 @output = output
	 @stream = StringIO.new
  end
  
  def info string , require_verbose = false
    @stream.puts(string) #if (  require_verbose && @verbose  || ! require_verbose )  
  end
  
  def log
    return  puts @stream.string  if @output.nil? 
	File.open(@output , "w") { |f| 
	 f.puts @stream.string }
  end  
end
