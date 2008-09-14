# Class For Translation
# Author:: eSpace technologies  www.eSpace.com.eg
# Copyright:: 2008

class Translator
  
      TABLE = {     "ہ"=>"A" , "ء"=>"A","آ"=>"A" ,"أ"=>"A","ؤ"=>"A", "إ"=>"A",
                                  "ا"=>"C" ,
                                  "ب"=>"E", "ة"=>"E" , "ت"=>"E" , "ث"=>"E", 
                                  "ج"=>"I" , "ح"=>"I" , "خ"=>"I" , "د"=>"I",
                                   "ر"=>"N" , 
                                   "ز"=>"O" , "س"=>"O" ,  "ش"=>"O" , "ص"=>"O" , "ض"=>"O" , 
                                   "ظ"=>"U" , "ع"=>"U" , "غ"=>"U" , "ـ"=>"U" , 
                                   "à"=>"a" , "ل"=>"a" , "â"=>"a" , "م"=>"a" , "ن"=>"a" , "ه"=>"a" ,
                                   "ç"=>"c" , 
                                   "è"=>"e" , "é"=>"e" , "ê"=>"e" ,  "ë"=>"e" , 
                                   "ى"=>"i" , "ي"=>"i" , "î"=>"i" , "ï"=>"i" ,  
                                   "ٌ"=>"n" , 
                                   "ٍ"=>"o" ,  "َ"=>"o" , "ô"=>"o" , "ُ"=>"o" , "ِ"=>"o" , 
                                   "ù"=>"u" , "ْ"=>"u" , "û"=>"u" , "ü"=>"u" , 
                                   "ئ"=>"AE" ,  "ٹ"=>"Sh" , "ژ"=>"Zh" , "ك"=>"ss" , "و"=>"ae" , "ڑ"=>"sh" , "‍"=>"zh" }  
  
  # * Translate The String
  def translate(string)
         result = ""
         i = 0
         ## IF non Utf8 Char return
         return string unless string.length % 2  ==0
         while i < string.length-1           
            char = string[i..i+1]
            result+=  TABLE[char].nil? ? char : TABLE[char]
            i+=2
          end
          result
  end
  
  def table(str)
    TABLE[str]
  end
end
