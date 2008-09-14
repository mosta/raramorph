#Dir[File.join(File.dirname(__FILE__), 'raramorph/**/*.rb')].sort.each { |lib| require lib }

$:.unshift File.expand_path(File.dirname(__FILE__) )
start = Time.now
require 'set'
require 'stringio'
require 'raramorph/logger'
require 'raramorph/translator'
require 'raramorph/arabic_latin_translator'
require 'raramorph/latin_arabic_translator'
require 'raramorph/in_memory_dictionary_handler'
require 'raramorph/in_memory_solutions_handler'
require 'raramorph/solution'
require 'raramorph/dictionary_entry'
require 'raramorph/raramorph'
puts "Time Elapsed loading dictionaries= " + ( Time.now - start).to_s
