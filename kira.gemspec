require_relative 'lib/kira/version'

Gem::Specification.new do |s|
  s.name        = 'kira'
  s.version     = Kira::VERSION
  s.executables = ['kira']
  s.summary     = "A (killer) sudoku solver."
  s.authors     = ["Wadim X. Janikowski"]
  s.email       = 'wadim.janikowski@gmail.com'
  s.files       = ["lib/kira.rb",
                   "lib/kira/group.rb",
                   "lib/kira/puzzle.rb",
                   "lib/kira/sudoku.rb",
                   "lib/kira/version.rb"]
  s.homepage    = 'https://github.com/wadiim/kira'
  s.license     = 'MIT'
end
