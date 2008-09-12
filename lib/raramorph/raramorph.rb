# A Ruby port of Buckwalter  Morphological Analyzer Version 1.0.
# 
# Author:: eSpace technologies  www.eSpace.com.eg
# Copyright:: 2008



class Raramorph

  # The dictionary handler.
  @@dict = InMemoryDictionaryHandler.create
  # The solutions handler.
  @@sol = InMemorySolutionsHandler.create
  # Whether or not the analyzer should output some convenience messages 
  # Alternative spellings list of regular expressions
  @@alternative_spellings = [Regexp.compile(".*" + "Y'$") ,  
                             Regexp.compile(".*" + "y'$") , 
                             Regexp.compile(".*" + "y$") , 
                             Regexp.compile(".*" + "h$") , 
                             Regexp.compile(".*" + "p$") ]
  @@space_regex = Regexp.compile("\\s+")
     
  # * Analyze and Process the file ( i.e Doing the morphological Analysis )
  # * [file_reader_in] Input File Path
  # * [output_buckwalter] whether the output in buckwalter indications ( i.e Roman letters ) or arabic letters
  def self.analyze(file_reader_in,output_buckwalter)
   # begin
     lines= IO.readlines(file_reader_in)
      lines.each do |line|
        @lines_counter+=1
        if(@logger.verbose)
           puts "Processing line : #{@lines_counter.to_s}"
        end
        tokens = tokenize(line)
        tokens.each do |token|
          analyze_token(token,output_buckwalter)
        end 
      end
    #rescue
    #  @logger.info "Can not read line " + @lines_counter.to_s
    #end    
  end
  
  # * Tokenize the Word removing non-arabic characters
  # * [str] Word to  be tokenized
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
  

  #  * Analyze Token doing the morphological Analysis
  # * [token] word to be analyzed 
  # * [output_buckwalter] whether the output in buckwalter indications ( i.e Roman letters ) or arabic letters
  def self.analyze_token(token ,  output_buckwalter) #STring  , Boolean , REturn Boolean
     #TO DO SET UP THE PRINT STREAM
     token.force_encoding "UTF-8"
     @logger.info "Processing token : " + "\t" + token
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
              @logger.info("Non-Arabic : #{sub_token}")
            end 
          }
          return false
     else
       has_solutions = false
       @not_arabic_tokens_counter+=1
       
       translitered = ArabicLatinTranslator.translate(token)
       @logger.info("Transliteration : \t#{translitered}")

      if @found.has_key?(translitered)        #Already processed : previously found
        @logger.info("Token already processed." , true )         
        #increase reference counter
        @found[translitered]+=1
        has_solutions = true
       elsif @not_found.has_key?(translitered) #Already processed : previously not found  
        @logger.info("Token already processed without solution." , true )
        @not_found[translitered]+=1         #increase reference counter
        has_solutions = false
       else
        @logger.info("Token not yet processed.", true )

        if (feed_word_solutions(translitered)) #CHANGED  #word has solutions...
          #mark word as found
          raise "There is already a key for " + translitered + " in found" if @found.has_key?(translitered)
          @logger.info("Token has direct solutions." , true )
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
               @logger.info("Token's alternative spellings have solutions." , true )
               #mark word as found set reference counter to 1
               @found[translitered] = 1
               has_solutions = true
             else
               #consistency check
               raise "There is already a key for " + translitered + " in notFound" if @not_found.has_key?(translitered)
               @logger.info("Token's alternative spellings have no solution." , true )
               @not_found[translitered]=1 
               has_solutions = false  
           end
         else
           #there are no alternative
           raise "There is already a key for " + translitered + " in notFound" if @not_found.has_key?(translitered)
           @logger.info("Token has no solution and no alternative spellings." , true )
           #mark word as not found and set reference counter to 1
           @not_found[translitered]=1 
           has_solutions = false  
         end
        end
      end
      
      
        #output solutions : TODO consider XML output
        if @logger.output != nil
          if @found.has_key?(translitered)
            if @@sol.has_solutions(translitered)
              @@sol.get_solutions(translitered).each{|solution| @logger.info "#{output_buckwalter ? solution.to_s : solution.to_arabized_string}" 
			  }
            end
            if @@sol.has_alternative_spellings(translitered) 
              @logger.info("No direct solution" , true )
              @@sol.get_alternative_spellings(translitered).each{|alternative| 
               @logger.info("Considering alternative spelling :" + "\t#{alternative}" , true )
                 if @@sol.has_solutions(alternative)
                   @@sol.get_solutions(alternative).each{|solution| @logger.info "#{output_buckwalter ? solution.to_s : solution.to_arabized_string}"
				   }
                 end
              }
            end            
          elsif @not_found.has_key?(translitered)
            @logger.info "\nNo solution\n"
          else
            raise "#{translitered} is neither in found or notFound !" 
          end
       end
        return has_solutions
        
     end     
  end

  # * Find the Solution for the translitered word
  #  * [translitered] word to be processed
  def self.feed_word_solutions(translitered) # String #Return Boolean
     #translitered.force_encoding "UTF-8"
     return true if @@sol.has_solutions(translitered) #No need to reprocess
     word_solutions = Set.new
     count = 0 
     #get a list of valid segmentations
     segments = segment_word(translitered) #Hash Set of Segement Words Objects
     #Brute force algorithm
     segments.each{|segmented_word|
	   count  = @@dict.analyze_word_in_dictionaries(segmented_word , word_solutions , @logger.verbose , count )
     }
    
      #Add all solutions, if any
    @@sol.add_solutions(translitered, word_solutions) unless word_solutions.empty?
    return !word_solutions.empty?  
  end
 
  # * Return the Solutions of the given Word
  # * [word] word to be proccessed
  def self.get_word_solutions(word) #String # Return Set
      word.force_encoding "UTF-8"
      word_solutions = Set.new
      translitered = ArabicLatinTranslator.translate(word)
      if @found.has_key?(translitered) 
        @@sol.get_solutions(translitered).each {|solution| word_solutions << solution }  if @@sol.has_solutions(translitered)
        if @@sol.has_alternative_spellings(translitered)
           @@sol.get_alternative_spellings(translitered).each {|alt|
           @@sol.get_solutions(alt).each {|solution| word_solutions << solution }  if @@sol.has_solutions(alt)}
       end
      elsif @not_found.has_key?(translitered)
      else 
         raise "#{translitered}  is neither in found or notFound !"
      end
    return word_solutions 
  end
  
  # * Segment the give word constructing prefix , stem , suffix
  # * [translitered] word to be proccessed
  def self.segment_word(translitered)
   # translitered.force_encoding "UTF-8"
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
    
    segmented
  end
  
  def self.print_stats
    total = (@found.length+@not_found.length).to_f
    puts "=================== Statistics ==================="
    puts "Lines : " + @lines_counter.to_s
    puts "Arabic tokens : " + @not_arabic_tokens_counter.to_s
    puts "Non-arabic tokens : " + @not_arabic_tokens_counter.to_s
    puts "Words found : " + @found.length.to_s + " (" + (((100*(@found.length*100 / total)).round())/100.0 ).to_s+ "%)"
    puts "Words not found : " + @not_found.length.to_s + " (" + (((100*(@not_found.length*100 / total)).round())/100.0 ).to_s + "%)"
    puts "=================================================="
    
  end
  
  # * Find Alternative Spellings for the translitered word
  # * [translitered] word to be proccesed
  def self.feed_alternative_spellings(translitered)
    return true  if(@@sol.has_alternative_spellings(translitered))
    word_alternative_spellings = Set.new
    temp = translitered
    
    if( temp.match(@@alternative_spellings[0]) )
      temp.gsub!(/Y/, "y")
      @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
      word_alternative_spellings.add(temp)
      temp2 = temp.sub(/w/, "&")
      if(temp!=temp2)
        temp = temp2
        @logger.info  "Found alternative spelling #{temp} for word #{translitered}" , true
        word_alternative_spellings.add(temp)
      end
      temp=translitered
      temp.gsub!(/Y/,"y")
      temp.sub!(/y'$/,"}")
      @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
      word_alternative_spellings.add(temp)
      temp2 = temp.sub(/w/, "&")
      if(temp!=temp2)
        temp = temp2
        @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
        word_alternative_spellings.add(temp)
      end
      
    elsif( temp.match(@@alternative_spellings[1]) )
      temp2 = temp.gsub(/Y/,"y")
      if(temp != temp2 )
        temp = temp2
        @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
        word_alternative_spellings.add(temp)
      end
      temp2 = temp.sub(/w'/, "&")
      if(temp != temp2 )
        temp = temp2
        @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
        word_alternative_spellings.add(temp)
      end
      temp =translitered
      temp.gsub!(/Y/, "y")
      temp.sub!(/y'$/, "}")
      @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
      word_alternative_spellings.add(temp)
      temp2 = temp.sub(/w'/, "&")
      if(temp != temp2 )
        temp = temp2
        @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
        word_alternative_spellings.add(temp)
      end
      
    elsif( temp.match(@@alternative_spellings[2]) )
      temp.gsub!(/Y/,"y")
      temp2 = temp.sub(/w'/, "&")
      if(temp != temp2 )
        temp = temp2
        @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
        word_alternative_spellings.add(temp)
      end
      temp =translitered
      temp.gsub!(/Y/, "y")
      temp.gsub!(/y$/, "Y")
      @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
      word_alternative_spellings.add(temp)
      temp2 = temp.sub(/w'/, "&")
      if(temp != temp2 )
        temp = temp2
        @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
        word_alternative_spellings.add(temp)
      end
      
      elsif( temp.match(@@alternative_spellings[3]) )
      temp2 = temp.gsub(/Y/,"y")
      if(temp != temp2 )
        temp = temp2
        @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
        word_alternative_spellings.add(temp)
      end
      temp2 = temp.sub(/w'/, "&")
      if(temp != temp2 )
        temp = temp2
        @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
        word_alternative_spellings.add(temp)
      end
      temp.sub!(/p$/, "h")
      @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
      word_alternative_spellings.add(temp)
    
    else
      temp2 = temp.sub(/Y$/, "y")
      if(temp!=temp2)
        temp = temp2
        temp.gsub!(/Y/, "y")
        @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
        word_alternative_spellings.add(temp)
        temp2 = temp.sub(/w'/, "&")
        if(temp != temp2 )
          temp = temp2
          @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
          word_alternative_spellings.add(temp)
        end
      else
        temp2 = temp.gsub(/Y/, "y")
        if(temp != temp2)
           @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
          word_alternative_spellings.add(temp)
          temp2 = temp.sub(/w'/, "&")
          if(temp != temp2 )
            temp = temp2
            @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
            word_alternative_spellings.add(temp)
          end   
        else
          temp2 = temp.sub(/w'/, "&")   
          if(temp != temp2 )
            temp = temp2
            @logger.info "Found alternative spelling #{temp} for word #{translitered}" , true
            word_alternative_spellings.add(temp)
          end      
        end
      end
    end
    
    if(!word_alternative_spellings.empty?)
      @@sol .add_alternative_spellings(translitered,word_alternative_spellings)
    end
    return !word_alternative_spellings.empty?      
   end

  # Executes the morphological Analyzer and Intitaite the variables
  # * [input_filename] input file path
  # * [output_filename] Output file path
  # * [verbose] Setter for verbose
  # * [not_arabic] alias for out_put_bucwalter for indicating the output format  in buckwalter indications or will be arabic 
  def self.execute(input_filename, output_filename ,verbose = false, not_arabic = false)
    @logger = Logger.new(true , output_filename )
    @not_arabic = not_arabic
    # Lines processed
    @lines_counter = 0
    # Arabic tokens processed
    @not_arabic_tokens_counter = 0
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
    analyze(input_filename , @not_arabic) 
    @logger.log
     print_stats
  end
 end  
 
 class SegmentedWord < Struct.new( :prefix , :stem , :suffix) ; end 

