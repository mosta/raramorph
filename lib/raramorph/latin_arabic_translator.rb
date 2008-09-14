# Class For  Latin Arabic Transileration
# Author:: eSpace technologies  www.eSpace.com.eg
# Copyright:: 2008


class LatinArabicTranslator
  
 # * Table Used for Tranlation From Latin Letters To Arabic I.e ( Arabize Word )
  # * According to  Buckwalter system Dictionary
  TABLE = {"'" => "\u0621","|" => "\u0622",">" => "\u0623","&" => "\u0624",
  "<" => "\u0625","}" => "\u0626","A" => "\u0627","b" => "\u0628",
  "p" => "\u0629","t" => "\u062A","v" => "\u062B","j" => "\u062C",
  "H" => "\u062D","x" => "\u062E","d" => "\u062F","*" => "\u0630",
  "r" => "\u0631","z" => "\u0632", "s" => "\u0633","$" => "\u0634","S" => "\u0635",
  "D" => "\u0636","T" => "\u0637","Z" => "\u0638","E" => "\u0639","g" => "\u063A", 
  "_" => "\u0640","f" => "\u0641","q" => "\u0642","k" => "\u0643","l" => "\u0644",
  "m" => "\u0645","n" => "\u0646","h" => "\u0647","w" => "\u0648","Y" => "\u0649","y" => "\u064A",
  "F" => "\u064B","N" => "\u064C","K" => "\u064D","a" => "\u064E","u" => "\u064F","i" => "\u0650",
  "~" => "\u0651", "o" => "\u0652",  "`" => "\u0670","{" => "\u0671","P" => "\u067E","J" => "\u0686",
  "V" => "\u06A4",   "G" => "\u06AF", "R" => "\u0698" ,"," => "\u060C" , ";" => "\u061B" , "?" => "\u061F"
  }
  
 # * Translate : Transilerate the Roman lettered word to  Arabic Word
 # * [word] Word String To be processed
 # * @return transilerated word
 #
  def self.translate(word)
   result = ""
   word.force_encoding "UTF-8"
   word.each_char{|char|
    result+= TABLE[char] ? TABLE[char] : char
   }   
   result
  end
end
