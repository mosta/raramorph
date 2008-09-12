Gem::Specification.new do |s|
  s.name     = "raramorph"
  s.version  = "0.1.0"
  s.date     = "2008-09-06"
  s.summary  = "Raramorph is a ruby gem for making morphological analysis and arabic indexing built using Ruby at eSpace-technologies ( www.espace.com.eg )"
  s.email    = "moustafa.emara@espace.com.eg"
  s.homepage = "http://github.com/espace/raramorph"
  s.description = "Raramorph is a ruby gem for making morphological analysis and arabic indexing built using Ruby at eSpace-technologies ( www.espace.com.eg )"
  s.has_rdoc = true
  s.authors  = ["Moustafa Emara" , "Hany Salah el deen"]
  s.platform = Gem::Platform::RUBY
  s.files    = [ 
		"raramorph.gemspec", 
		"lib/raramorph/raramorph.rb",
		"lib/raramorph/solution.rb",
		"lib/raramorph/dictionary_entry.rb",
		"lib/raramorph/in_memory_dictionary_handler.rb",
		"lib/raramorph/in_memory_solutions_handler.rb",
		"lib/raramorph/translator.rb",
		"lib/raramorph/arabic_latin_translator.rb",
		"lib/raramorph/latin_arabic_translator.rb",
		"lib/raramorph/in_memory_dictionary_handler.rb",
		"lib/raramorph/logger.rb",
		"lib/dictionaries/dictPrefixes",
		"lib/dictionaries/dictStems",
		"lib/dictionaries/dictSuffixes",
		"lib/dictionaries/marshal_stems",
		"lib/dictionaries/tableAB",
		"lib/dictionaries/tableAC",
		"lib/dictionaries/tableBC",
                "lib/raramorph.rb",
                "lib/raramorph_main.rb", 
                "lib/test_input/UTF-8.txt"
	]
  s.executables = %w(raramorph)
  s.required_ruby_version = '>= 1.9'
  s.bindir = "bin"
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README"]
  #s.extensions << "ext/extconf.rb"
end
