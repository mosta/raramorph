# An in-memory handler for managing solutions found by the morphological analyzer.
# 
# Author:: eSpace technologies  www.eSpace.com.eg
# Copyright:: 2008
#

class InMemorySolutionsHandler
  
  # The unique instance of this handler (singleton pattern)
  # Constructor to avoid multiple instanciations
  public_class_method :new
  @@handler = nil
  
  def self.create
    @@handler= new unless @@handler
    @@handler
  end
    
  public
  
  # Add solutions for a given word
  # * [translitered] The translitered word.
  # * [sol] The solution to the translitered word.
  def add_solutions (translitered, sol)
    @@solutions[translitered] = sol
  end

  # Whether or not the word already gave solutions
  # * [translitered] The translitered word	  
  #  * @return If it has the solution or not (Boolean).
  def has_solutions(translitered)
    @@solutions.has_key?(translitered)
  end

  # Return the solutions of a given word
  # * [translitered] The translitered word
  #  * @return The solution matching the transliterd word.
  def get_solutions(translitered)
    if(self.has_solutions(translitered))
      return @@solutions[translitered]
    else
      return nil
    end
  end

  # Add alternative spellings for the given word
  # * [translitered] The translitered word
  # * [alt] The alternative spelling
  def add_alternative_spellings(translitered, alt)
    @@alternative_spellings[translitered] = alt
  end

  # Whether or not the word already gave alternative spellings
  # * [translitered] The translitered word
  #  * @return If the transliterd word has alternative spellings
  def has_alternative_spellings(translitered)
    @@alternative_spellings.has_key?(translitered)
  end

  # Return the alternative spellings of the word
  # * [translitered] The translitered word
  #  * @return The alternative spellings matching the transliterd word.
  def get_alternative_spellings(translitered)
    if(self.has_alternative_spellings(translitered))
      return @@alternative_spellings[translitered]
    else
      return nil
    end    
  end 

private
    #Hash of solutions for analyzed words
    @@solutions ={}
    #Hash of alternative spellings
    @@alternative_spellings ={}

end
  
