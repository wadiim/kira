#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'kira'

files = Dir.glob('test/*.in').sort!
total = 0
REPETITIONS = 5

begin
  files.each do |f|
    test_name = f.delete_suffix('.in').delete_prefix("test/")

    file = File.open('test/' + test_name + '.in')
    puzzle = file.read
    file.close

    file = File.open('test/' + test_name + '.out')
    solution = file.read.strip
    file.close

    printf("%s:", test_name)

    0.upto(REPETITIONS) do
      sudoku = Kira::Sudoku.new(puzzle)

      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      sudoku.solve
      finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      solved = sudoku.to_s.strip


      if solved != solution
        STDERR.puts "Invalid solution\n"\
                    "Expected:\n#{solution}\n"\
                    "Got:\n#{sudoku.to_s}"
        exit(false)
      end

      elapsed = finish - start
      total += elapsed
      printf(" %0.4f", elapsed)
    end
    printf("\n")
  end
  printf("total: %0.4f\n", total)
  printf("average: %0.4f\n", total / (files.size * REPETITIONS))
rescue Interrupt
  printf("\n")
  exit
end
