# A Ruby port of Buckwalter Arabic Morphological Analyzer Version 1.0.
# 
# Author:: eSpace technologies  www.eSpace.com.eg
# Copyright:: 2008

class Raramorph


  # Whether or not the analyzer should output some convenience messages 
  @verbose
  # The stream where to output the results 

  @output_stream
  #Stats
  # Lines processed
   @lines_counter = 0
  # Arabic tokens processed
   @arabic_tokens_counter = 0
  # Not arabic tokens processed 
   @not_arabic_tokens_counter = 0

  # Arabic words which have been succesfully analyzed.
  # * [key] = word
  # * [value] = occurences
  #
   @found = {}

  # Arabic words which have not been succesfully analyzed.
  # * [key] = word
  # * [value] = occurences
  #
   @not_found = {}   
  
  # Alternative spellings list of regular expressions
  @@alternative_spellings = []
  @@alternative_spellings[0] = Regexp.compile(".*" + "Y'$")
  @@alternative_spellings[1] = Regexp.compile(".*" + "y'$")
  @@alternative_spellings[2] = Regexp.compile(".*" + "y$")
  @@alternative_spellings[3] = Regexp.compile(".*" + "h$")
  @@alternative_spellings[4] = Regexp.compile(".*" + "p$")
  @@space_regex = Regexp.compile("\\s+")
     
  def initialize(output_stream = nil , verbose =false)
   # The dictionary handler.
    @@dict = InMemoryDictionaryHandler.create
    @@feed_time = 0
    @@in_word = 0
  # The solutions handler.
  @@sol = InMemorySolutionsHandler.create
    @output_stream = output_stream
    @verbose = verbose
    # Lines processed
    @lines_counter = 0
    # Arabic tokens processed
    @arabic_tokens_counter = 0
    # Not arabic tokens processed 
    @not_arabic_tokens_counter = 0
    # Arabic words which have been succesfully analyzed.
    # * [key] = word
    # * [value] = occurences
    #
    @found = {}
    # Arabic words which have not been succesfully analyzed.
    # * [key] = word
    # * [value] = occurences
    #
    @not_found = {}
    @@seg_time = 0
    @@time_in_alt = 0
    @stream = StringIO.new
  end
  
  def self.set_verbose(verbose) #Bolean Variable
    @verbose = verbose
  end
  
  def self.analyze(line_number_reader_in,output_buckwalter)
   # begin
    @@tokenize_time = 0
     lines= IO.readlines(line_number_reader_in)
      lines.each do |line|
        @lines_counter+=1
        if(@verbose)
           puts "Processing line : "+ @lines_counter.to_s
        end
       a = Time.now 
        tokens = tokenize(line)
 #     @@tokenize_time += Time.now - a
        tokens.each do |token|
          analyze_token(token,output_buckwalter)
        end 
      end
    #rescue
    #  @stream.puts "Can not read line " + @lines_counter.to_s
    #end    
  end
  
  def self.tokenize(str) #String , REturn String
    str.force_encoding "UTF-8"
    str = str.strip
    str = str.gsub(@@space_regex, " ")
    #ignored \u0688 : ARABIC LETTER DDAL
    #ignored \u06A9 : ARABIC LETTER KEHEH
    #ignored \u0691 : ARABIC LETTER RREH
    #ignored \u06BA : ARABIC LETTER NOON GHUNNA
    #ignored \u06BE : ARABIC LETTER HEH DOACHASHMEE
    #ignored \u06C1 : ARABIC LETTER HEH GOAL
    #ignored \u06D2 : ARABIC LETTER YEH BARREE
    split  = str.split(/[^\u067E\u0686\u0698\u06AF\u0621-\u0636\u0637-\u0643\u0644\u0645-\u0648\u0649-\u064A\u064B-\u064E\u064F\u0650\u0651\u0652]+/)
    tokens = []
    #return at least one token, the string if necessary
    split.length == 0 ?  (tokens << str) : split    
  end
  
  def self.analyze_token(token ,  output_buckwalter) #STring  , Boolean , REturn Boolean
     #TO DO SET UP THE PRINT STREAM
     token.force_encoding "UTF-8"
     @stream.puts "Processing token : " + "\t" + token
     #TODO : check accuracy
     #ignored \u0688 : ARABIC LETTER DDAL
     #ignored \u06A9 : ARABIC LETTER KEHEH
     #ignored \u0691 : ARABIC LETTER RREH
     #ignored \u06BA : ARABIC LETTER NOON GHUNNA
     #ignored \u06BE : ARABIC LETTER HEH DOACHASHMEE
     #ignored \u06C1 : ARABIC LETTER HEH GOAL
     #ignored \u0640 : ARABIC TATWEEL
     #ignored \u06D2 : ARABIC LETTER YEH BARREE
     unless(token.match(/([\u067E\u0686\u0698\u06AF\u0621-\u063A\u0641-\u0652])+/))
         token.strip!
         # tokenize it on white space
          sub_tokens = token.split(@@space_regex)
          sub_tokens.each{|sub_token|
            unless  sub_token.strip == ""  
              @not_arabic_tokens_counter+=1
              @output_stream != nil ? @stream.puts("Non-Arabic : " + sub_token) : puts("Non-Arabic : " + sub_token)
            end 
          }
          return false
     else
       has_solutions = false
       @arabic_tokens_counter+=1
       translitered = ArabicLatinTranslator.translate(token)
       @output_stream != nil ? @stream.puts("Transliteration : " + "\t" + translitered) : puts("Transliteration : " + "\t" + translitered)
       if @found.has_key?(translitered)        #Already processed : previously found
        @output_stream != nil  && @verbose ? @stream.puts("Token already processed.") : puts("Token already processed.")          
        #increase reference counter
        @found[translitered]+=1
        has_solutions = true
       elsif @not_found.has_key?(translitered) #Already processed : previously not found  
        @output_stream != nil  && @verbose ? @stream.puts("Token already processed without solution.") : puts("Token already processed without solution.")          
        @not_found[translitered]+=1         #increase reference counter
        has_solutions = false
       else
        @output_stream != nil  && @verbose ? @stream.puts("Token not yet processed.") : puts("Token not yet processed.")          

        if (feed_word_solutions(translitered)) #CHANGED  #word has solutions...
          #mark word as found
          raise "There is already a key for " + translitered + " in found" if @found.has_key?(translitered)
          @output_stream != nil  && @verbose ? @stream.puts("Token has direct solutions.") : puts("Token has direct solutions.")          
          #set reference counter to 1
          @found[translitered] = 1
          has_solutions = true
        else #word has no direct solution
           if(feed_alternative_spellings(translitered))
             alternatives_give_solutions = false
             alternatives = @@sol.get_alternative_spellings(translitered)              
             alternatives.each{|alternative|
              alternatives_give_solutions =  (alternatives_give_solutions || feed_word_solutions(alternative))
             }
             if(alternatives_give_solutions)
               #consistency check
               raise "There is already a key for " + translitered + " in found" if @found.has_key?(translitered)
               @output_stream != nil  && @verbose ? @stream.puts("Token's alternative spellings have solutions.") : puts("Token's alternative spellings have solutions.")
               #mark word as found set reference counter to 1
               @found[translitered] = 1
               has_solutions = true
             else
               #consistency check
               raise "There is already a key for " + translitered + " in notFound" if @not_found.has_key?(translitered)
               @output_stream != nil  && @verbose ? @stream.puts("Token's alternative spellings have no solution.") : puts("Token's alternative spellings have no solution.")
               @not_found[translitered]=1 
               has_solutions = false  
           end
         else
           #there are no alternative
           raise "There is already a key for " + translitered + " in notFound" if @not_found.has_key?(translitered)
           @output_stream != nil  && @verbose ? @stream.puts("Token has no solution and no alternative spellings.") : puts("Token has no solution and no alternative spellings.")
           #mark word as not found and set reference counter to 1
           @not_found[translitered]=1 
           has_solutions = false  
         end
        end
      end
      
      
        #output solutions : TODO consider XML output
        if @output_stream != nil
          if @found.has_key?(translitered)
            if @@sol.has_solutions(translitered)
              @@sol.get_solutions(translitered).each{|solution| @stream.puts "#{output_buckwalter ? solution.to_s : solution.to_arabized_string}"}
            end
            if @@sol.has_alternative_spellings(translitered) 
              @output_stream != nil  && @verbose ? @stream.puts("No direct solution") : puts("No direct solution")   
              @@sol.get_alternative_spellings(translitered).each{|alternative| 
                 @output_stream != nil  && @verbose ? @stream.puts("Considering alternative spelling :" + "\t" + alternative) : puts("Considering alternative spelling :" + "\t" + alternative)   
                 if @@sol.has_solutions(alternative)
                   @@sol.get_solutions(alternative).each{|solution| @stream.puts "#{output_buckwalter ? solution.to_s : solution.to_arabized_string}"}
                 end
              }
            end            
          elsif @not_found.has_key?(translitered)
            @stream.puts "\nNo solution\n"
          else
            raise "#{translitered} is neither in found or notFound !" 
          end
       end
        return has_solutions
        
     end     
  end

  def self.feed_word_solutions(translitered) # String #Return Boolean
     #translitered.force_encoding "UTF-8"
     return true if @@sol.has_solutions(translitered) #No need to reprocess
     word_solutions = Set.new
     count = 0 
          f = Time.now
     #get a list of valid segmentations
     segments = segment_word(translitered) #Hash Set of Segement Words Objects
           @@in_word += Time.now - f 
     #Brute force algorithm
        s = Time.now
     segments.each{|segmented_word|
       #Is prefix known ?
       if @@dict.has_prefix?(segmented_word.prefix)
         #Is stem known ?
         # puts "has prefix"
         if @@dict.has_stem?(segmented_word.stem)
          # puts "has stem"
           #Is suffix known ?
           if @@dict.has_suffix?(segmented_word.suffix)
           #  puts "has suffix"
             #Compatibility check
              @@dict.prefixes[segmented_word.prefix].each{|prefix|
                @@dict.stems[segmented_word.stem].each {|stem|
                  #Prefix/Stem compatibility
                    if @@dict.prefixes_stems_compatible?(prefix.morphology ,stem.morphology )
                      # puts "has A B Com" 
                      @@dict.suffixes[segmented_word.suffix].each {|suffix|
                       # Prefix/Suffix compatiblity
                       if @@dict.prefixes_suffixes_compatible?(prefix.morphology , suffix.morphology)
                         # puts "has A C Com"
                          # Stems/Suffixes compatiblity
                         if @@dict.stems_suffixes_compatible?(stem.morphology , suffix.morphology)
                          # puts "has  B  C COM"
                            #All tests passed : it is a solution
                            count = count + 1
                            word_solutions << Solution.new(@verbose , count , prefix , stem , suffix )
                         end
                       end
                      }
                    end
                }
              }
           end
         end
       end
     }
    
      #Add all solutions, if any
    @@sol.add_solutions(translitered, word_solutions) unless word_solutions.empty?
     @@feed_time += Time.now - s
    return !word_solutions.empty?  
  end
 
  def self.get_word_solutions(word) #String # Return Set
      word.force_encoding "UTF-8"
      word_solutions = Set.new
      translitered = ArabicLatinTranslator.translate(word)
      if @found.has_key?(translitered) 
        @sol.get_solutions(translitered).each {|solution| word_solutions << solution }  if @sol.has_solutions(translitered)
        if @sol.has_alternative_spellings(translitered)
           @sol.get_alternative_spellings(translitered).each {|alt|
           @sol.get_solutions(alt).each {|solution| word_solutions << solution }  if @sol.has_solutions(alt)}
       end
      elsif @not_found.has_key?(translitered)
      else 
         raise "#{translitered}  is neither in found or notFound !"
      end
    return word_solutions 
  end
 
  def self.print_usage
    puts("Arabic Morphological Analyzer for Ruby")
    puts("Ported to Ruby  by Moustafa Emara and Hany Salah El din , eSpace-technologies.(www.espace.com.eg) ,  2008.")
    puts("Based on :")
    puts("BUCKWALTER ARABIC MORPHOLOGICAL ANALYZER")
    puts("This program is developed under the Ruby-Licences")
    puts("Usage :")
    puts("")
    puts("RaraMorph inFile  outFile verbose output_buckwalter")
    puts("")
    puts("inFile : file to be analyzed")
    puts("outFile : result file, default console")
    puts("Third Argument verbose mode Boolean Variable")
    puts("Fourth Argument Buckwalter Output mode Boolean Variable")
  end
  
  
  def self.segment_word(translitered)
   # translitered.force_encoding "UTF-8"
    stime = Time.now
    segmented = Set.new
    prefix_len = 0
    suffix_len = 0
    
    while(prefix_len <=4 and prefix_len<=translitered.length)
      prefix = translitered.slice(0,prefix_len)
      stem_len = translitered.length - prefix_len
      suffix_len = 0
      
      while(stem_len>=1 and suffix_len<=6)
        stem = translitered.slice(prefix_len,stem_len)
        suffix = translitered.slice(prefix_len+stem_len,suffix_len)
        segmented.add(SegmentedWord.new(prefix,stem,suffix))
        stem_len-=1
        suffix_len+=1
      end
      
      prefix_len+=1
    end
      
       @@seg_time += Time.now - stime
    segmented
  end
  
  def self.print_stats  
    total = (@found.length+@not_found.length).to_f
    puts "=================== Statistics ==================="
    puts "Lines : " + @lines_counter.to_s
    puts "Arabic tokens : " + @arabic_tokens_counter.to_s
    puts "Non-arabic tokens : " + @not_arabic_tokens_counter.to_s
    puts "Words found : " + @found.length.to_s + " (" + ((@found.length / total)* 100 ).to_s + ")"
    puts "Words not found : " + @not_found.length.to_s + " (" + ((@not_found.length / total)* 100).to_s + ")"
    puts "Time In Feed Alternative  :" + @@time_in_alt.to_s
    puts "Time In Segment Word : " + @@seg_time.to_s
    puts "Time In Feed word Sol : " + @@feed_time.to_s
    puts "Time In In Feeed : "  + @@in_word.to_s
    puts "Tokenize Time :  " + @@tokenize_time.to_s
    puts "=================================================="
  end
  
  def self.feed_alternative_spellings(translitered)
   t = Time.now
            return true  if(@@sol.has_alternative_spellings(translitered))
    word_alternative_spellings = Set.new
    temp = translitered
    
    if( temp.match(@@alternative_spellings[0]) )
      temp.gsub!(/Y/, "y")
      if(@verbose)
        @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
      end
      word_alternative_spellings.add(temp)
      temp2 = temp.sub(/w/, "&")
      if(temp!=temp2)
        temp = temp2
        if(@verbose)
          @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
        end
        word_alternative_spellings.add(temp)
      end
      temp=translitered
      temp.gsub!(/Y/,"y")
      temp.sub!(/y'$/,"}")
      if(@verbose)
        @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
      end
      word_alternative_spellings.add(temp)
      temp2 = temp.sub(/w/, "&")
      if(temp!=temp2)
        temp = temp2
        if(@verbose)
          @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
        end
        word_alternative_spellings.add(temp)
      end
      
    elsif( temp.match(@@alternative_spellings[1]) )
      temp2 = temp.gsub(/Y/,"y")
      if(temp != temp2 )
        temp = temp2
        if(@verbose)
          @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
        end
        word_alternative_spellings.add(temp)
      end
      temp2 = temp.sub(/w'/, "&")
      if(temp != temp2 )
        temp = temp2
        if(@verbose)
          @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
        end
        word_alternative_spellings.add(temp)
      end
      temp =translitered
      temp.gsub!(/Y/, "y")
      temp.sub!(/y'$/, "}")
      if(@verbose)
        @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
      end
      word_alternative_spellings.add(temp)
      temp2 = temp.sub(/w'/, "&")
      if(temp != temp2 )
        temp = temp2
        if(@verbose)
          @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
        end
        word_alternative_spellings.add(temp)
      end
      
    elsif( temp.match(@@alternative_spellings[2]) )
      temp.gsub!(/Y/,"y")
      temp2 = temp.sub(/w'/, "&")
      if(temp != temp2 )
        temp = temp2
        if(@verbose)
          @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
        end
        word_alternative_spellings.add(temp)
      end
      temp =translitered
      temp.gsub!(/Y/, "y")
      temp.gsub!(/y$/, "Y")
      if(@verbose)
        @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
      end
      word_alternative_spellings.add(temp)
      temp2 = temp.sub(/w'/, "&")
      if(temp != temp2 )
        temp = temp2
        if(@verbose)
          @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
        end
        word_alternative_spellings.add(temp)
      end
      
      elsif( temp.match(@@alternative_spellings[3]) )
      temp2 = temp.gsub(/Y/,"y")
      if(temp != temp2 )
        temp = temp2
        if(@verbose)
          @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
        end
        word_alternative_spellings.add(temp)
      end
      temp2 = temp.sub(/w'/, "&")
      if(temp != temp2 )
        temp = temp2
        if(@verbose)
          @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
        end
        word_alternative_spellings.add(temp)
      end
      temp.sub!(/p$/, "h")
      if(@verbose)
        @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
      end
      word_alternative_spellings.add(temp)
    
    else
      temp2 = temp.sub(/Y$/, "y")
      if(temp!=temp2)
        temp = temp2
        temp.gsub!(/Y/, "y")
        if(@verbose)
          @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
        end
        word_alternative_spellings.add(temp)
        temp2 = temp.sub(/w'/, "&")
        if(temp != temp2 )
          temp = temp2
          if(@verbose)
            @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
          end
          word_alternative_spellings.add(temp)
        end
      else
        temp2 = temp.gsub(/Y/, "y")
        if(temp != temp2)
          if(@verbose)
            @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
          end
          word_alternative_spellings.add(temp)
          temp2 = temp.sub(/w'/, "&")
          if(temp != temp2 )
            temp = temp2
            if(@verbose)
              @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
            end
            word_alternative_spellings.add(temp)
          end   
        else
          temp2 = temp.sub(/w'/, "&")   
          if(temp != temp2 )
            temp = temp2
            if(@verbose)
              @stream.puts "Found alternative spelling "+ temp + " for word " + translitered
            end
            word_alternative_spellings.add(temp)
          end      
        end
      end
    end
    
    if(!word_alternative_spellings.empty?)
      @@sol .add_alternative_spellings(translitered,word_alternative_spellings)
    end
     @@time_in_alt += Time.now - t
    return !word_alternative_spellings.empty?      
   end

  def self.execute(input_file_name ,out_put_file_name , verbose , buckwalter )    
    @verbose = verbose
    analyze(input_file_name , buckwalter) 
    File.open(out_put_file_name , "w") do |f|
      f.puts @stream.string
    end
  end
 end  
 
  class SegmentedWord
    attr_reader :prefix , :stem , :suffix
    def initialize(prefix , stem , suffix)
      @prefix = prefix
      @stem = stem
      @suffix = suffix
    end
  end
