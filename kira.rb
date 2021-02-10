#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require './lib/index'
require './lib/group'
require './lib/puzzle'
require './lib/sudoku'

if __FILE__ == $0
  begin
    input = $stdin.read
    sudoku = Kira::Sudoku.new(input)
    sudoku.solve
    puts sudoku.to_s + "\n"
  rescue StandardError => e
    puts "Error: " + e.message
  end
end
