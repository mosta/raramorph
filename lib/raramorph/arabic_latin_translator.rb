# Class For Arabic Latin Transileration
# Author:: eSpace technologies  www.eSpace.com.eg
# Copyright:: 2008
#

class ArabicLatinTranslator 
  
  # * Table Used for Tranlation From Arabic To English I.e ( Romanize Word )
  # * According to  Buckwalter system Dictionary
  TABLE =   { "\u0621"=> "'" , "\u0622"=> "|" , "\u0623"=> ">" , "\u0624"=> "&" , "\u0625"=> "<" , "\u0626"=> "}" ,
  "\u0627"=> "A" , "\u0628"=> "b" , "\u0629"=> "p" , "\u062A"=> "t" , "\u062B"=> "v" , "\u062C"=> "j" ,
  "\u062D"=> "H" , "\u062E"=> "x" , "\u062F"=> "d" , "\u0630"=> "*" , "\u0631"=> "r" , "\u0632"=> "z" ,
  "\u0633"=> "s" , "\u0634"=> "$" , "\u0635"=> "S" , "\u0636"=> "D" , "\u0637"=> "T" ,"\u0638"=> "Z",
  "\u0639"=> "E" , "\u063A"=> "g" , "\u0640"=> "_" , "\u0641"=> "f" , "\u0642"=> "q" , "\u0643"=> "k" , 
  "\u0644"=> "l" , "\u0645"=> "m" , "\u0646"=> "n" , "\u0647"=> "h" , "\u0648"=> "w" , "\u0649"=> "Y", 
  "\u064A"=> "y" , "\u064B"=> "F" , "\u064C"=> "N" , "\u064D"=> "K" , "\u064E"=> "a" , "\u064F"=> "u" ,
  "\u0650"=> "i" , "\u0651"=> "~" , "\u0652"=> "o" , "\u0670"=> "`" ,"\u0671"=> "{" , "\u067E"=> "P" ,
  "\u0686"=> "J" , "\u06A4"=> "V" , "\u06AF"=> "G" , "\u0698"=> "R" , "\u060C" => "," ,"\u061B" => ";",
  "\u061F" => "?" , "\u0640" => ""   }
  #Not suitable for morphological analysis : remove all vowels/diacritics, i.e. undo the job !
  VOWEL_REMOVER = Regexp.compile("[FNKaui~o]")
  STRIPER =  Regexp.compile("[`\\{]")

 
 # * Translate : Transilerate the arabic word to  Roman lettered Word
 # * [word] Word String To be processed
 # * @return transilerated word
 #
 def self.translate(word)
   result = ""
   word.gsub!(VOWEL_REMOVER , "")
   word.gsub!(STRIPER , "")
   word.force_encoding "UTF-8"
   word.each_char{|char|
    result+= TABLE[char] ? TABLE[char] : char
   }   
   result
 end
 
end
