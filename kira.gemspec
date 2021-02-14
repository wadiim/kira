Gem::Specification.new do |s|
  s.name        = 'kira'
  s.version     = '0.0.9'
  s.executables = ['kira']
  s.summary     = "A killer sudoku solver."
  s.authors     = ["Wadim X. Janikowski"]
  s.email       = 'wadim.janikowski@gmail.com'
  s.files       = ["lib/kira.rb",
                   "lib/kira/index.rb",
                   "lib/kira/group.rb",
                   "lib/kira/puzzle.rb",
                   "lib/kira/sudoku.rb"]
  s.license     = 'MIT'
end
