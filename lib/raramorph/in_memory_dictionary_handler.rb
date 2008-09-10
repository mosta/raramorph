# Class For Storing And Loading Dictionaries
# Author:: eSpace technologies  www.eSpace.com.eg
# Copyright:: 2008
#

require 'rubygems'
class InMemoryDictionaryHandler
  
  #Signleton Class
      ##### Dictionaries ########
    #### Dictionaries are HASH OF ARRAYS #####
       @@prefixes = {}
    #Dictionary of Prefixes

       @@stems = {}
    #Dictionary of Stems
 
       @@suffixes = {}
     #Dictionary of Suffixes
   private_class_method :new
     
  # * Loads Dictionaries and initiate variables 
  def self.create 
    
    ### Variables #####
      @@handler  = nil
      @@regex = Regexp.compile(".*" + "<pos>(.+?)</pos>" + ".*")
      @@morphology_regexs=[]
      #@@leema_starter = Regexp.compile(";; ")
      @@morphology_regexs[0] = Regexp.compile("^(Pref-0|Suff-0)$")
      @@morphology_regexs[1] = Regexp.compile("^F" + ".*")
      @@morphology_regexs[2] = Regexp.compile("^IV" + ".*")
      @@morphology_regexs[3] = Regexp.compile("^PV" + ".*")
      @@morphology_regexs[4] = Regexp.compile("^CV" + ".*")
      @@morphology_regexs[5] = Regexp.compile("^N" + ".*")
      @@morphology_regexs[6] = Regexp.compile("^[A-Z]" + ".*")
      @@morphology_regexs[7] = Regexp.compile(".*" + "iy~$")
      @@compatability_stpliter = Regexp.compile("\\s+")            
      @@vocalization_array =[]
      @@vocalization_array[0] = "/FUNC_WORD"
      @@vocalization_array[1] ="/VERB_IMPERFECT"
      @@vocalization_array[2] ="/VERB_PERFECT"
      @@vocalization_array[3] ="/VERB_IMPERATIVE"
      @@vocalization_array[4] = "/NOUN_PROP"
      @@vocalization_array[5] ="/NOUN"
      @@vocalization_array[6] = "/NOUN"
  
      @@prefixes_stems_compatibility = Set.new
    #Changed
    #Compatibility table for prefixes-stems combinations.
  
      @@prefixes_suffixes_compatibility = Set.new
    #Changed
    #Compatibility table for prefixes-suffixes combinations.
  
      @@stems_suffixes_compatibility = Set.new
      
    #Changed
    #Compatibility table for stem-suffixes combinations.

       puts "Initializing in-memory dictionary handler..."
       Thread.abort_on_exception = true
       load_dictionary( @@prefixes , "dictPrefixes"  ,  File.dirname(__FILE__) + "/../dictionaries/dictPrefixes"  )
       load_stems_marshaled_dictionary
       load_dictionary(@@suffixes, "dictSuffixes" ,  File.dirname(__FILE__) + "/../dictionaries/dictSuffixes")
       load_compatibility_table(@@prefixes_stems_compatibility , "prefixes_stems_compatibility" ,  File.dirname(__FILE__) + "/../dictionaries/tableAB")
       load_compatibility_table(@@prefixes_suffixes_compatibility , "prefixes_suffixes_compatibility" ,  File.dirname(__FILE__) + "/../dictionaries/tableAC")
       load_compatibility_table(@@stems_suffixes_compatibility , "stems_suffixes_compatibility" ,  File.dirname(__FILE__) + "/../dictionaries/tableBC")
       puts "... Done ... "
             @@handler = new unless @@handler
  end
  
  # * load the marshaled stems dictionary if avalaible or load from the origin dictionary if not avalaible
  def self.load_stems_marshaled_dictionary 
     if File.exists?( File.dirname(__FILE__) + '/../dictionaries/marshal_stems' ) 
      File.open( File.dirname(__FILE__) + '/../dictionaries/marshal_stems') do |f|  
         @@stems =  Marshal.load(f)
       end
        puts("#{@@stems.length}  entries totalizing")
     else
       reload_stems_dictionary
     end         
  end
  
  # * Marshal the stems dictionary into a file
  def self.marshal_stems
     File.open( File.dirname(__FILE__) + '/../dictionaries/marshal_stems' , 'w+') do |f|  
        Marshal.dump(@@stems, f)  
      end   
  end
  

  # * Loads Stem dictionary from original file then marshal the dictionary for faster access
  def self.reload_stems_dictionary
    load_dictionary(@@stems, "dictStems",  File.dirname(__FILE__) + "/../dictionaries/dictStems") #File.open("dictionaries/dictStems" ,  "r:UTF-8" ))
    marshal_stems
  end
  
   # * Check if translitered word has prefix
   # * [translitered] Translitered word to be checked
  def has_prefix?(translitered)
   	@@prefixes.has_key?(translitered)
  end

   # * Check if translitered word has stem
   # * [translitered] Translitered word to be checked   
  def has_stem?(translitered)
    @@stems.has_key?(translitered)
  end
  
   # * Check if translitered word has suffix
   # * [translitered] Translitered word to be checked
  def has_suffix?(translitered)
    @@suffixes.has_key?(translitered)
  end
  
   # * Check if prefix and stem are compatible 
   # * [prefix] prefix to be checked
   # * [stem] stem to be checked
  def prefixes_stems_compatible?(prefix , stem) #String , #String
    @@prefixes_stems_compatibility.member?(prefix + " " + stem)
  end
  
   # * Check if prefix and suffix are compatible 
   # * [prefix] prefix to be checked
   # * [suffix] suffix to be checked
  def prefixes_suffixes_compatible?(prefix , suffix)
    @@prefixes_suffixes_compatibility.member?(prefix + " " + suffix)
  end
  
   # * Check if stem and suffix are compatible 
   # * [stem] stem to be checked
   # * [suffix] suffix to be checked
  def stems_suffixes_compatible?(stem , suffix)
    @@stems_suffixes_compatibility.member?(stem + " " + suffix)
  end
  
  # * Returns the prefixes table
  def prefixes
    @@prefixes
  end
  
  def prefixes=(prefixes)
    @@prefixes = prefixes
  end
  
  # * Returns Stems Dictionary
  def stems
    @@stems
  end
   
  def stems=(stems)
    @@stems = stems
  end
  
  
 # * Returns Suffixes Dictionary
  def suffixes
    @@suffixes
  end
  
  def suffixes=(suffixes)
    @@suffixes = suffixes
  end
  
 private 
 
  # * load Dictionary from files  
  # * [dictionary]  Hash of Arrays to store the Dictionary 
  # * [name] Dictionary Name
  # * [file] File Path
  def self.load_dictionary(  dictionary , name , file )
     lemmas = Set.new
     forms = 0
     final  = 0
     lemma_id = ""
     puts "Loading Dictionary : #{ name }"
     #x  = Time.now
     file = IO.readlines(file)
     #@loading_secs += Time.now - x
     line_count = 0 
   #  leemas = file.select{|line| line.start_with?(@@leema_starter) }
     file  = file.select{|line| line.start_with?(";; ") or !line.start_with?(";")  }
    # entries = file.select{|line| !( line.start_with?(@@leema_starter) and line.start_with?(";")) }
    # read_leemas(leemas)
    # read_entries(entries)


     file.each do |line|
       # puts "." unless line_count % 1000
        if line.start_with?(";; ")
           lemma_id = line[3..line.length]
          # Raise Exception If non-unique Lemma ID
            raise ArgumentError.new("Lemma #{lemma_id } in #{name} #{line_count}  isn't unique") if lemmas.member?(lemma_id)
          # Add The New Lemma
           lemmas << lemma_id
        #elsif line.start_with?(";")
        else           
           splited_line =  line.split("\t" , -1)
           raise ArgumentError.new("Entry In #{name} line #{line_count} doesn't have 4 fields ( 3 tabs )") unless splited_line.length == 4   
           de = self.construct_dictionary_entry(splited_line , name, line_count , lemma_id)
           if  dictionary.has_key?(de.entry)
        		dictionary[de.entry] << de
      	   else 
                 tmp_array = [] 
                 tmp_array << de                 
                 dictionary[de.entry] = tmp_array
            end  
           forms+=1; 
       end
       line_count+=1
    end
  #  file.close() 
       #puts "Time Taken In If"  + @@if_time.to_s
       #puts "Time Taken In Sub"  + @@sub_time.to_s
     
     puts "#{lemmas.size()}  lemmas and " unless lemma_id == ""
     puts("#{dictionary.length}  entries totalizing  #{forms}  forms")
  end 
   
  # * Load Compatibilty tables
  # * [set] Set for Loading Compatibilty Tables
  # * [name] Table Name
  # * [file] File Path
  def self.load_compatibility_table(set, name, file)
    puts "Loading compatibility table : #{name}  "
    file = IO.readlines(file)
     file.each do |line|
       unless (line.start_with?(";")) #Ignore comments
		line = line.strip
		line = line.gsub(@@compatability_stpliter, " ")
		set << line#line
      end
   end
   	puts  "#{set.size()} entries"
 end  
 
  # * Construct Dictionary Entry from line 
  def self.construct_dictionary_entry(splited_line , name  ,line_count , lemma_id)
             entry  = splited_line[0] 
             vocalization = splited_line[1]
             morphology = splited_line[2]
             gloss_pos = splited_line[3]
             gloss , pos = "" 
             # two ways to get the POS info
             # (1) explicitly, by extracting it from the gloss field:
            
             matcher = @@regex.match(gloss_pos) 
              if matcher
                 pos = matcher[1] #extract POS from glossPOS
    		         gloss = gloss_pos #we clean up the gloss later (see below)
              	# (2) by deduction: use the morphology (and sometimes the voc and gloss) to deduce the appropriate POS                 
             else
                 gloss= gloss_pos
                 # we need the gloss to guess proper name
                 
                  if morphology.match(@@morphology_regexs[0])
                    pos  = ""
                  elsif morphology.match(@@morphology_regexs[1])
                    pos = "#{vocalization} #{@@vocalization_array[0]}"
            		  elsif (morphology.match(@@morphology_regexs[2]))
            		    pos = "#{vocalization} #{ @@vocalization_array[1]}"
           	  	  elsif (morphology.match(@@morphology_regexs[3])) 
            		    pos = "#{vocalization} #{ @@vocalization_array[2]}"
    		          elsif (morphology.match(@@morphology_regexs[4] )) 
            		    pos = "#{vocalization} #{@@vocalization_array[3]}"
           		    elsif (morphology.match(@@morphology_regexs[5])) 
                            # educated guess (99% correct)  
            			  if (gloss.match(@@morphology_regexs[6])) 
         			      pos = "#{vocalization} #{@@vocalization_array[4]}"			
					    		  #(was NOUN_ADJ: some of these are really ADJ's and need to be tagged manually)
            			  elsif (vocalization.match(@@morphology_regexs[7]))
          			     pos = "#{vocalization} #{@@vocalization_array[5]}"
   		              else 
          			     pos = "#{vocalization} #{@@vocalization_array[6]}"
                    end                  
                  else   raise "No POS can be deduced in #{ name}  (line  #{line_count}"
                end
            end   
            # clean up the gloss: remove POS info and extra space, and convert upper-ASCII  to lower (it doesn't convert well to UTF-8)
             gloss =gloss.sub(/<pos>.+?<\/pos>/,"")
       	     gloss = gloss.strip 
             translotor = Translator.new
             gloss = translotor.translate(gloss)
             DictionaryEntry.new(entry, lemma_id, vocalization, morphology, gloss, pos)
    end
end
