# ARGV[0] # Input File Name
# ARGV[1] # Outpute File Name
# ARGV[2] # Verbose Default False
# ARGV[4] # BuckWalter  Default False ( Arabic Output)
 $:.unshift File.expand_path(File.dirname(__FILE__) )
 if ARGV.length >= 2 and ARGV.length <= 4 
 require 'raramorph' 
 start = Time.now
 verbose = false
 arabic = false
 verbose = true  if ARGV[2] and ARGV[2] == "-v" 
 not_arabic = false  if ARGV[3] and ARGV[3] == "-a" 
 not_arabic = false if ARGV[2] and ARGV[2] == "-a"   
 Raramorph.execute(ARGV[0] , ARGV[1] , verbose , arabic )
    puts "Time Elapsed= " + ( Time.now - start).to_s
 else
    puts("Arabic Morphological Analyzer for Ruby")
    puts("Ported to Ruby  by Moustafa Emara and Hany Salah El din , eSpace-technologies.(www.espace.com.eg) ,  2008.")
    puts("Based on :")
    puts("BUCKWALTER ARABIC MORPHOLOGICAL ANALYZER")
    puts("This program is developed under the MIT-Licences")
    puts("Usage :")
    puts("")
    puts("raraMorph inFile [inEncoding] [outFile]  [-v] [-a]")
    puts("")
    puts("inFile : file to be analyzed")
    puts("inEncoding : encoding for inFile, default UTF-8")
    puts("outFile : result file ")
    puts("-v : verbose mode")
    puts("-a : Aarbic Output" )
 end



