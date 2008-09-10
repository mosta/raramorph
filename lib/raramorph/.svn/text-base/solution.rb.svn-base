# A class to find the solution of the word
# 
# Author:: eSpace technologies  www.eSpace.com.eg
# Copyright:: 2008
#


class Solution
  
  attr_reader :prefix, :stem, :suffix, :cnt
  
  protected
    
  # Constructs a solution for a word. Note that the prefix, stem and suffix combination is <b>recomputed</b> 
  #and may not necessarily match with the information provided by the dictionaries.	  
  # * [debug] Whether or not the dictionnaries inconsistencies should be output
  # * [cnt] Order in sequence ; not very useful actually
  # * [prefix The prefix as provided by the prefixes dictionnary
  # * [stem] The stem as provided by the stems dictionnary
  # * [suffix] The suffix as provided by the suffixes dictionnary
  #
  def initialize(debug, cnt, prefix, stem, suffix) 
      # Whether or not the dictionnaries inconsistencies should be output 
      @debug = debug; 
      # The order in solutions' sequence.
      @cnt = cnt;
      # The dictionary entry of the prefix.
      @prefix = prefix;
      # The dictionary entry of the stem.
      @stem = stem;
      # The dictionary entry of the suffix.
      @suffix = suffix;
      # The prefixes POS.
      @prefixesPOS = prefix.pos
      #The stems POS.
      @stemsPOS = stem.pos
      #The suffixes POS.
      @suffixesPOS = suffix.pos
      #The prefixes glosses.
      @prefixesGlosses = prefix.glosses
      #The stems glosses
      @stemsGlosses = stem.glosses
      #The suffixes glosses.
      @suffixesGlosses = suffix.glosses
      
    if (@stemsPOS.length != @stemsGlosses.length)
        if (@debug) 
          puts "\"" + get_lemma() + "\" : stem's sizes for POS (" + @stemsPOS.length.to_s + ") and GLOSS ("+ @stemsGlosses.length.to_s + ") do not match"
        end
      end            				
      
      #Normalize stems since some of them can contain prefixes
    
      while(@stemsPOS.length>0)
              stemPOS = @stemsPOS.slice(0)
              if(stemPOS)
                stemPOS.force_encoding "UTF-8"
              end
              if (@stemsGlosses.length>0) 
                stemGloss = @stemsGlosses.slice(0)
              else 
                stemGloss = nil
              end
              if(stemGloss)
                stemGloss.force_encoding "UTF-8"
              end
              if (stemPOS.end_with?("CONJ") or 
                    stemPOS.end_with?("EMPHATIC_PARTICLE") or 
                    stemPOS.end_with?("FUNC_WORD") or 
                    stemPOS.end_with?("FUT_PART") or 
                    stemPOS.end_with?("INTERJ") or 
                    stemPOS.end_with?("INTERROG_PART") or 
                    stemPOS.end_with?("IV1S") or 
                    stemPOS.end_with?("IV2MS") or 
                    stemPOS.end_with?("IV2FS") or 
                    stemPOS.end_with?("IV3MS") or 
                    stemPOS.end_with?("IV3FS") or 
                    stemPOS.end_with?("IV2D") or 
                    stemPOS.end_with?("IV2FD") or 
                    stemPOS.end_with?("IV3MD") or 
                    stemPOS.end_with?("IV3FD") or 
                    stemPOS.end_with?("IV1P") or 
                    stemPOS.end_with?("IV2MP") or 
                    stemPOS.end_with?("IV2FP") or 
                    stemPOS.end_with?("IV3MP") or 
                    stemPOS.end_with?("IV3FP") or 
                    stemPOS.end_with?("NEG_PART") or 
                    stemPOS.end_with?("PREP") or 
                    stemPOS.end_with?("RESULT_CLAUSE_PARTICLE") ) 
                      @stemsPOS.slice!(0)
                      @prefixesPOS.push(stemPOS)
                      if (stemGloss) 
                        @stemsGlosses.slice!(0)
                        @prefixesGlosses.push(stemGloss)
                      end
              else 
                      break					
              end
      end              
      
      #Normalize stems since some of them can contain suffixes    
      while(@stemsPOS.length>0)
              stemPOS = @stemsPOS.slice(@stemsPOS.length-1)
              if(stemPOS)
                stemPOS.force_encoding "UTF-8"
              end
              if (@stemsGlosses.length>0) 
                stemGloss = @stemsGlosses.slice(@stemsGlosses.length-1)
              else 
                stemGloss = nil
              end              
              if(stemGloss)
                stemGloss.force_encoding "UTF-8"
              end
              
              if (stemPOS.end_with?("CASE_INDEF_NOM") or 
                    stemPOS.end_with?("CASE_INDEF_ACC") or 
                    stemPOS.end_with?("CASE_INDEF_ACCGEN") or 
                    stemPOS.end_with?("CASE_INDEF_GEN") or 
                    stemPOS.end_with?("CASE_DEF_NOM") or 
                    stemPOS.end_with?("CASE_DEF_ACC") or 
                    stemPOS.end_with?("CASE_DEF_ACCGEN") or 
                    stemPOS.end_with?("CASE_DEF_GEN") or 
                    stemPOS.end_with?("NSUFF_MASC_SG_ACC_INDEF") or 
                    stemPOS.end_with?("NSUFF_FEM_SG") or 
                    stemPOS.end_with?("NSUFF_MASC_DU_NOM") or 
                    stemPOS.end_with?("NSUFF_MASC_DU_NOM_POSS") or 
                    stemPOS.end_with?("NSUFF_MASC_DU_ACCGEN") or 
                    stemPOS.end_with?("NSUFF_MASC_DU_ACCGEN_POSS") or 
                    stemPOS.end_with?("NSUFF_FEM_DU_NOM") or 
                    stemPOS.end_with?("NSUFF_FEM_DU_NOM_POSS") or 
                    stemPOS.end_with?("NSUFF_FEM_DU_ACCGEN") or 
                    stemPOS.end_with?("NSUFF_FEM_DU_ACCGEN_POSS") or 
                    stemPOS.end_with?("NSUFF_MASC_PL_NOM") or 
                    stemPOS.end_with?("NSUFF_MASC_PL_NOM_POSS") or 
                    stemPOS.end_with?("NSUFF_MASC_PL_ACCGEN") or 
                    stemPOS.end_with?("NSUFF_MASC_PL_ACCGEN_POSS") or 
                    stemPOS.end_with?("NSUFF_FEM_PL") or 
                    stemPOS.end_with?("POSS_PRON_1S") or 
                    stemPOS.end_with?("POSS_PRON_2MS") or 
                    stemPOS.end_with?("POSS_PRON_2FS") or 
                    stemPOS.end_with?("POSS_PRON_3MS") or 
                    stemPOS.end_with?("POSS_PRON_3FS") or 
                    stemPOS.end_with?("POSS_PRON_2D") or 
                    stemPOS.end_with?("POSS_PRON_3D") or 
                    stemPOS.end_with?("POSS_PRON_1P") or 
                    stemPOS.end_with?("POSS_PRON_2MP") or 
                    stemPOS.end_with?("POSS_PRON_2FP") or 
                    stemPOS.end_with?("POSS_PRON_3MP") or 
                    stemPOS.end_with?("POSS_PRON_3FP") or 
                    stemPOS.end_with?("IVSUFF_DO:1S") or 
                    stemPOS.end_with?("IVSUFF_DO:2MS") or 
                    stemPOS.end_with?("IVSUFF_DO:2FS") or 
                    stemPOS.end_with?("IVSUFF_DO:3MS") or 
                    stemPOS.end_with?("IVSUFF_DO:3FS") or 
                    stemPOS.end_with?("IVSUFF_DO:2D") or 
                    stemPOS.end_with?("IVSUFF_DO:3D") or 
                    stemPOS.end_with?("IVSUFF_DO:1P") or 
                    stemPOS.end_with?("IVSUFF_DO:2MP") or 
                    stemPOS.end_with?("IVSUFF_DO:2FP") or 
                    stemPOS.end_with?("IVSUFF_DO:3MP") or 
                    stemPOS.end_with?("IVSUFF_DO:3FP") or 
                    stemPOS.end_with?("IVSUFF_MOOD:I") or 
                    stemPOS.end_with?("IVSUFF_SUBJ:2FS_MOOD:I") or 
                    stemPOS.end_with?("IVSUFF_SUBJ:D_MOOD:I") or 
                    stemPOS.end_with?("IVSUFF_SUBJ:3D_MOOD:I") or 
                    stemPOS.end_with?("IVSUFF_SUBJ:MP_MOOD:I") or 
                    stemPOS.end_with?("IVSUFF_MOOD:S") or 
                    stemPOS.end_with?("IVSUFF_SUBJ:2FS_MOOD:SJ") or 
                    stemPOS.end_with?("IVSUFF_SUBJ:D_MOOD:SJ") or 
                    stemPOS.end_with?("IVSUFF_SUBJ:MP_MOOD:SJ") or 
                    stemPOS.end_with?("IVSUFF_SUBJ:3MP_MOOD:SJ") or 
                    stemPOS.end_with?("IVSUFF_SUBJ:FP") or 
                    stemPOS.end_with?("PVSUFF_DO:1S") or 
                    stemPOS.end_with?("PVSUFF_DO:2MS") or 
                    stemPOS.end_with?("PVSUFF_DO:2FS") or 
                    stemPOS.end_with?("PVSUFF_DO:3MS") or 
                    stemPOS.end_with?("PVSUFF_DO:3FS") or 
                    stemPOS.end_with?("PVSUFF_DO:2D") or 
                    stemPOS.end_with?("PVSUFF_DO:3D") or 
                    stemPOS.end_with?("PVSUFF_DO:1P") or 
                    stemPOS.end_with?("PVSUFF_DO:2MP") or 
                    stemPOS.end_with?("PVSUFF_DO:2FP") or 
                    stemPOS.end_with?("PVSUFF_DO:3MP") or 
                    stemPOS.end_with?("PVSUFF_DO:3FP") or 
                    stemPOS.end_with?("PVSUFF_SUBJ:1S") or 
                    stemPOS.end_with?("PVSUFF_SUBJ:2MS") or 
                    stemPOS.end_with?("PVSUFF_SUBJ:2FS") or 
                    stemPOS.end_with?("PVSUFF_SUBJ:3MS") or 
                    stemPOS.end_with?("PVSUFF_SUBJ:3FS") or 
                    stemPOS.end_with?("PVSUFF_SUBJ:2MD") or 
                    stemPOS.end_with?("PVSUFF_SUBJ:2FD") or 
                    stemPOS.end_with?("PVSUFF_SUBJ:3MD") or 
                    stemPOS.end_with?("PVSUFF_SUBJ:3FD") or 
                    stemPOS.end_with?("PVSUFF_SUBJ:1P") or 
                    stemPOS.end_with?("PVSUFF_SUBJ:2MP") or 
                    stemPOS.end_with?("PVSUFF_SUBJ:2FP") or 
                    stemPOS.end_with?("PVSUFF_SUBJ:3MP") or 
                    stemPOS.end_with?("PVSUFF_SUBJ:3FP") or 
                    stemPOS.end_with?("CVSUFF_DO:1S") or 
                    stemPOS.end_with?("CVSUFF_DO:3MS") or 
                    stemPOS.end_with?("CVSUFF_DO:3FS") or 
                    stemPOS.end_with?("CVSUFF_DO:3D") or 
                    stemPOS.end_with?("CVSUFF_DO:1P") or 
                    stemPOS.end_with?("CVSUFF_DO:3MP") or 
                    stemPOS.end_with?("CVSUFF_DO:3FP") or 
                    stemPOS.end_with?("CVSUFF_SUBJ:2MS") or 
                    stemPOS.end_with?("CVSUFF_SUBJ:2FS") or 
                    stemPOS.end_with?("CVSUFF_SUBJ:2MP")  ) 
                      @stemsPOS.slice!(@stemsPOS.length-1)
                      @suffixesPOS.insert(0,stemPOS)
                      if (stemGloss) 
                        @stemsGlosses.slice!(@stemsGlosses.length-1)
                        @suffixesGlosses.insert(0,stemGloss)
                      end
              else 
                      break					
              end
      end

      #Normalization of bayon, bayona, bayoni
      if (@stemsPOS.length > 1) 			
          pos0 = @stemsPOS[0]
          pos1 = @stemsPOS[1]
          if(pos1=="bayon" or pos1=="bayona" or pos1=="bayoni")			
                  if (@debug) 
                    puts "Merging \""+pos1+"\" into first part of stem \"" + pos0 + "\""
                  end
                  array = pos0.split("/");				
                  sb = array[0] + pos1+"/"
                  i=1
                  while( i < array.length)
                          sb+=array[i]
                  end
                  @stemsPOS.slice!(0)
                  @stemsPOS[0] = sb
          end
      end		 

      # Sanity check
      if (@stemsPOS.length > 1 and @debug) 
            puts"More than one stem for " + @stemsPOS.to_string()
      end    
  end 
  
  
  # Returns the lemma id in the stems dictionary.
  #  * @return The lemma ID
  #
  def get_lemma
    x = Regexp.compile("(_|-).*$") 
    @stem.lemma_id.sub(x,"")
  end
  
  
  # Returns the vocalizations of the <b>recomputed</b> prefixes in the Buckwalter transliteration system 
  # or  <b>nil</b> if there are no prefixes for the word.
  #  * @return The vocalizations
  #
  def get_prefixes_vocalizations
    vocalizations(false,@prefixesPOS,false)
  end

  # Returns the vocalizations of the <b>recomputed</b> prefixes in arabic 
  # or <b>nil</b> if there are no prefixes for the word.
  #  * @return The vocalizations
  #  
  def get_prefixes_arabic_vocalizations
    vocalizations(true,@prefixesPOS,false)
  end
  
  # Returns the vocalization of the <b>recomputed</b> stem in the Buckwalter transliteration system 
  # or <b>nil</b> if there is no stem for the word.
  #  * @return The vocalization
  #  
  def get_stem_vocalization
    vocalizations(false,@stemsPOS,true)
  end
  
  # Returns the vocalization of the <b>recomputed</b> stem in arabic
  # or <b>nil</b> if there is no stem for the word.
  #  * @return The vocalization
  #  
  def get_stem_arabic_vocalization
    vocalizations(true,@stemsPOS,true)
  end

  # Returns the vocalizations of the <b>recomputed</b> suffixes in the Buckwalter transliteration system 
  # or  <b>nil</b> if there are no suffixes for the word.
  #  * @return The vocalizations
  #
  def get_suffixes_vocalizations
    vocalizations(false,@suffixesPOS,false)
  end

  # Returns the vocalizations of the <b>recomputed</b> suffixes in arabic 
  # or <b>nil</b> if there are no suffixes for the word.
  #  * @return The vocalizations
  #  
  def get_suffixes_arabic_vocalizations
    vocalizations(true,@suffixesPOS,false)
  end
  
  
  # Returns the vocalization of the word in the Buckwalter transliteration system.
  #  * @return The vocalization
  #  
  def get_word_vocalization
    sb = ""
    sb.force_encoding "UTF-8"
    vocal = get_prefixes_vocalizations()
    if(vocal!=nil)
      sb += vocal[0].to_s
    end
    
    s =get_stem_vocalization() 
    if ( s != nil) 
      sb+=s
    end
    vocal =get_suffixes_vocalizations()
    if(vocal!=nil)
      sb += vocal[0].to_s
    end
    
    return sb
  end
    
  # Returns the vocalization of the word in arabic.
  #  * @return The vocalization
  #  
  def get_word_arabic_vocalization
    sb = ""
    sb.force_encoding "UTF-8"
    vocal = get_prefixes_arabic_vocalizations()
    if(vocal!=nil)
      sb += vocal[0].to_s
    end
    
    s = get_stem_arabic_vocalization() 
    if ( s != nil) 
      sb+=s
    end
    vocal = get_suffixes_arabic_vocalizations()    
    if(vocal!=nil)
      sb += vocal[0].to_s
    end
    
    return sb
  end
  
  # Returns the morphology of the prefix.
  #  * @return The morphology
  #  
  def get_prefix_morphology
    @prefix.morphology
  end

  # Returns the morphology of the stem.
  #  * @return The morphology
  #  
  def get_stem_morphology
    @stem.morphology
  end

  # Returns the morphology of the suffix.
  #  * @return The morphology
  #  
  def get_suffix_morphology
    @suffix.morphology
  end
  
  # Returns the morphology of the word.
  #  * @return The morphology
  #
  def get_word_morphology
    sb = ""
    sb.force_encoding "UTF-8"
    if (!@prefix.morphology.empty? and @prefix.morphology != nil )
          sb+= "\t" + "prefix : " + @prefix.morphology + "\n"
    end
    if (!@stem.morphology.empty? and @stem.morphology != nil)
          sb+= "\t" + "stem : " + @stem.morphology + "\n"
    end
    if (!@suffix.morphology.empty? and @suffix.morphology != nil)
          sb+= "\t" + "suffix : " + @suffix.morphology + "\n"
    end
    return sb
   end
   
  # Returns the grammatical categories of the <b>recomputed</b> prefixes 
  # or <b>nil</b> if there are no prefixes for the word.
  #  * @return The grammatical categories
  #
  def get_prefixes_POS
    perform_on_POS(1,@prefixesPOS,1)
  end
   
  # Returns The vocalizations using the Buckwalter transliteration system of the  <b>recomputed</b> prefixes and their grammatical categories
  # or <b>nil</b> if there are no prefixes for the word.
  #  * @return The vocalizations and the grammatical categories
  #
  def get_prefixes_long_POS
    perform_on_POS(2,@prefixesPOS,1)
  end
   
  # Returns The vocalizations in arabic of the <b>recomputed</b> prefixes and their grammatical categories
  # or <b>nil</b> if there is no stem for the word.
  #  * @return The vocalizations and the grammatical categories.
  #
  def get_prefixes_arabic_long_POS
    perform_on_POS(3,@prefixesPOS,1)
  end
  
  # Returns the grammatical category of the <b>recomputed</b> stem.
  #  * @return The grammatical category
  #  
  def get_stem_POS
    perform_on_POS(1,@stemsPOS,2)
  end
   
  # Returns The vocalization using the Buckwalter transliteration system of the <b>recomputed</b> stem and its grammatical category 
  # or <b>nil</b> if there is no stem for the word.
  #  * @return The vocalizations and the grammatical categories.
  #
  def get_stem_long_POS
    perform_on_POS(2,@stemsPOS,2)
  end
   
  # Returns The vocalization in arabic of the <b>recomputed</b> stem and its grammatical category 
  # or <b>nil</b> if there is no stem for the word.
  #  * @return The vocalizations and the grammatical categories.
  #
  def get_stem_arabic_long_POS
    perform_on_POS(3,@stemsPOS,2)
  end
   
  # Returns The vocalization in arabic of the <b>recomputed</b> stem and its grammatical category 
  # or <b>nil</b> if there is no stem for the word.
  #  * @return The grammatical categories
  #
  def get_suffixes_POS
    perform_on_POS(1,@suffixesPOS,3)
  end
   
  # Returns The vocalizations using the Buckwalter transliteration system of the <b>recomputed</b> stem and its grammatical category 
  # or <b>nil</b> if there is no stem for the word.
  #  * @return The vocalizations and the grammatical categories.
  #
  def get_suffixes_long_POS
    perform_on_POS(2,@suffixesPOS,3)
  end
   
  # Returns The vocalization in arabic of the <b>recomputed</b> stem and its grammatical category 
  # or <b>nil</b> if there is no stem for the word.
  #  * @return The vocalizations and the grammatical categories.
  #
  def get_suffixes_arabic_long_POS
    perform_on_POS(3,@suffixesPOS,3)
  end

  # Returns The vocalization of the word in the Buckwalter transliteration system and its grammatical categories.
  #  * @return The vocalization and the grammatical categories
  #  
  def get_word_long_POS
    word_POS(false)
  end

  # Returns The vocalization of the word in arabic and its grammatical categories.
  #  * @return The vocalization and the grammatical categories
  #  
  def get_word_arabic_long_POS
    word_POS(true)
  end
  
  # Returns the english glosses of the prefixes.
  #  * @return The glosses.
  #  	
  def get_prefixes_glosses
    if(@prefixesGlosses.empty?)
      return nil
    else
      return @prefixesGlosses
    end
  end	

  # Returns the english gloss of the stem.
  #  * @return The gloss.
  #  
  def get_stem_gloss
    if (@stemsGlosses.empty?) 
      return nil
    end
    if ((@stemsGlosses.length > 1) and @debug) 
      puts "More than one gloss for " + @stemsGlosses.to_s
    end
    #return the first anyway :-(
    return @stemsGlosses[0]

  end			
	
  # Returns the english glosses of the suffixes.
  #  * @return The glosses.
  #  
  def get_suffixes_glosses
    if(@suffixesGlosses.empty?)
      return nil
    else
      return @suffixesGlosses
    end
  end	
	
  # Returns the english glosses of the word.
  #  * @return The glosses.
  #  
  def get_word_glosses
    sb = ""
    sb.force_encoding "UTF-8"
    glosses = get_prefixes_glosses()
    if (glosses and glosses[0] != nil) 
          sb+=("\t" + "prefix : " + glosses[0].gsub(";","/") + "\n")	        
    end
    if (get_stem_gloss() != nil) 
      sb+=("\t" + "stem : " +get_stem_gloss().gsub(";","/") + "\n")	
    end
    glosses = get_suffixes_glosses()
    if (glosses and glosses[0] != nil)       
          sb+=("\t" + "suffix : " + glosses[0].gsub(";","/") + "\n")	       
    end
    return sb
  end
  
  # Returns a string representation of how the word can be analyzed using the Buckwalter transliteration system for the vocalizations.
  # * @return The representation
  # 
  public
  def to_s
    ret = ""
    ret.force_encoding "UTF-8"
    ret = "\n SOLUTION # #{ @cnt.to_s} \n Lemma  :  #{ get_lemma()  } \n
       Vocalized as :  \t #{get_word_vocalization()} \n
       Morphology :  \n #{ get_word_morphology()}
      Grammatical category :   \n
      #{get_word_long_POS()} Glossed as :  \n
      #{get_word_glosses()} "
    ret
  end
	
  # Returns a string representation of how the word can be analyzed using arabic for the vocalizations..
  #  * @return The representation
  #  
  def to_arabized_string
    ret = ""
    ret.force_encoding "UTF-8"
    ret = "\n SOLUTION # #{ @cnt.to_s} \n Lemma  :  #{ get_lemma()  } \n
       Vocalized as :  \t #{get_word_arabic_vocalization()} \n
       Morphology :  \n #{ get_word_morphology()}
      Grammatical category :   \n
      #{get_word_arabic_long_POS()} Glossed as :  \n
      #{get_word_glosses()} "
    ret
  end	
  
  private
    
  # Returns an array of vocalizations according to type specified in the given parameters	  
  # * [arabic] Whether or not vocalization is for arabic	  
  # * [arr] The array utilized, either of prefixes, stems, suffixes	  
  # * [one] Whether or not we are manipulating single vocalization (only true for stem vocalizations, false for suffixes and prefixes)
  #  
  def vocalizations(arabic, arr, one)
    if (arr.empty?)
      return nil
    end
    vocalizations = []	
    arr.each do |pos|
            array = pos.split("/")	
            if(arabic)
              sb = LatinArabicTranslator.translate(array[0])
              sb.force_encoding "UTF-8"
              vocalizations <<  sb
            else
              vocalizations <<  array[0]
            end
    end
    if(one)
      if ( (vocalizations.length > 1) and @debug) 
        puts "More than one stem for " + vocalizations.to_s
      end
      return vocalizations[0]
    else
      return vocalizations
    end            
  end   
  
  # Returns an array of vocalizations according to type specified in the given parameters	  
  # * [type] Specifies  the type of the function to perform, (1 for regular, 2 for long, 3 for arabic)
  # * [arr] The array utilized, either of prefixes, stems, suffixes	  
  # * [pre_stem_suff] Specifying which type of arrays are being handled (1 for prefixes, 2 for stems, 3 for suffixes)
  #  
  def perform_on_POS(type, arr, pre_stem_suff)
    if (arr.empty?) 
      return nil
    end
    temp_POS = []
    arr.each do |pos|
      array = pos.split("/");
      j=1
      if(type==1)
        sb = ""
      elsif(type==2)
        sb = array[0] + "\t"
      else
        sb = LatinArabicTranslator.translate(array[0]) + "\t"
        sb.force_encoding "UTF-8"
      end
      while( j < array.length)
        if (j > 1) 
          sb+=" / "
        end
        sb+=array[j]
        j+=1
      end
      temp_POS.push(sb)
    end
    
    if(pre_stem_suff==2)
      if ((temp_POS.length > 1) and @debug) 
        puts "More than one stem for " + temp_POS.to_s
      end
      if (type ==1 and temp_POS[0].empty?) 
        puts "Empty POS for stem " + get_stem_long_POS()
      end
      #return the first anyway :-(
      return temp_POS[0]	        
    else
      return temp_POS
    end
  end
  
  # Returns the vocalizations and the grammatical categories	  
  # * [arabic] Boolean to choose, Buckwalter transliteration system or arabic
  # 
  def word_POS(arabic)    
    sb=""
    if(arabic)
      temp_POS =get_prefixes_arabic_long_POS()	
    else
      temp_POS =get_prefixes_long_POS()	
    end
    if (temp_POS != nil)             			
              if (temp_POS[0]!=nil) 
                sb+=("\t" + "prefix : " + temp_POS[0] + "\n")
              end	
    end
    if(arabic)
      s = get_stem_arabic_long_POS()
    else
      s = get_stem_long_POS()
    end
    if ( s != nil) 
      sb+=("\t" + "stem : " + s + "\n")
    end
    if(arabic)
      temp_POS =get_suffixes_arabic_long_POS()	
    else
      temp_POS =get_suffixes_long_POS()	
    end
    if (temp_POS != nil)             		
              if (temp_POS[0]!=nil) 
                sb+=("\t" + "suffix : " + temp_POS[0] + "\n")
              end	
    end
    return sb
  end 
end
