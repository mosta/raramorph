# Class For Storing Dictionary Entries
# Author:: eSpace technologies  www.eSpace.com.eg
# Copyright:: 2008


class DictionaryEntry
        ## Constructs a Dictionary Entry
        
       attr_reader :entry , :lemma_id , :vocalization , :morphology , :gloss , :glosses , :pos
       @@split_regex = Regexp.compile("\\+") 
       
	protected  
  # * Initiliaze New Dict. Entry
 def initialize( entry,  lemma_id,  vocalization,  morphology,  gloss,  pos)
               # Instance Variables
		@entry = entry.strip
		@lemma_id = lemma_id.strip
    @vocalization = vocalization.strip
		@morphology = morphology.strip
		@gloss = gloss
    @glosses = []
    @pos = []              
    @glosses = fill_instance_array_from_sent_array(gloss.split(@@split_regex))
	  @pos = fill_instance_array_from_sent_array(pos.split(@@split_regex))              
 end
 
 private  
 def fill_instance_array_from_sent_array( sent_array)         	
  instance_array = []
 	sent_array.each do  |value |  
	 	value = value.strip
  end
   sent_array[0] == "" ?  offset = 1 :  offset = 0
  for i in offset..sent_array.length-1 
		instance_array[i - offset] = sent_array[i]
  end
  instance_array
 end

end
