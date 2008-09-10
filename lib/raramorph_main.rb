# ARGV[0] # Input File Name
# ARGV[1] # Outpute File Name
# ARGV[2] # Verbose Default False
# ARGV[4] # BuckWalter  Default False ( Arabic Output)
 $:.unshift File.expand_path(File.dirname(__FILE__) )
 if ARGV.length >= 2 and ARGV.length <= 4 
 require 'raramorph' 
 start = Time.now
 Raramorph.execute(ARGV[0] , ARGV[1] , ARGV[2] , ARGV[3] )
    puts "Time Elapsed= " + ( Time.now - start).to_s
 else
    puts("Arabic Morphological Analyzer for Ruby")
    puts("Ported to Ruby  by Moustafa Emara and Hany Salah El din , eSpace-technologies.(www.espace.com.eg) ,  2008.")
    puts("Based on :")
    puts("BUCKWALTER ARABIC MORPHOLOGICAL ANALYZER")
    puts("This program is developed under the Ruby-Licences")
    puts("Usage :")
    puts("")
    puts("RaraMorph inFile [inEncoding] [outFile] [outEncoding] [-v]")
    puts("")
    puts("inFile : file to be analyzed")
    puts("inEncoding : encoding for inFile, default UTF-8")
    puts("outFile : result file, default console")
    puts("outEncoding : encoding for outFile, if not specified use Buckwalter transliteration with system's file.encoding")
    puts("-v : verbose mode")
 end



