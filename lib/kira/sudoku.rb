# -*- coding: utf-8 -*-

require 'kira/group'
require 'kira/puzzle'

module Kira

  # A Killer Sudoku solver. It is initialized with a string containing a grid
  # followed by any number of equations. The grid consists of digits from 1 to
  # 9 and dots representing an empty cell. Each equation has to be on its own
  # line.
  class Sudoku
    def initialize(string)
      grid = ""
      @groups = []
      string.each_line do
        |line|
        if line.match("^[1-9\. \t\n\r]*$")
          grid << line
        else
          @groups.push(Group.new(line))
        end
      end

      @puzzle = Puzzle.new(grid)
    end

    attr_reader :puzzle, :groups

    def to_s
      @puzzle.to_s
    end

    def solve()
      if @puzzle.solved?
        return true
      end

      # Find the index of an empty cell with the smallest number of
      # possibilities.
      min_idx = 0
      1.upto(80) do
        |i|
        if (@puzzle[i] == 0 and
            @puzzle.grid_of_possibilities[i].size <
            @puzzle.grid_of_possibilities[min_idx].size) or
            @puzzle[min_idx] != 0 and @puzzle[i] == 0

          min_idx = i
        end
      end

      possibilities = @puzzle.grid_of_possibilities[min_idx].dup
      possibilities.delete_if { |p| valid?(p, min_idx) == false }

      while possibilities.size > 0 do
        @puzzle[min_idx] = possibilities.pop

        if solve
          return true
        end
      end

      @puzzle[min_idx] = 0
      false
    end

    # Returns true if the 'val' on the given 'pos' does not repeat in a column,
    # row, box or group and all the equations are satisfied.
    def valid?(val, pos)
      unless @puzzle.grid_of_possibilities[pos].include?(val)
        return false
      end

      @groups.each do |g|
        unless g.indexes.include?(pos)
          next
        end

        sum = val

        # Set to true when the group contains an empty cell at position other
        # than 'pos'.
        empty_cell = false

        g.indexes.each do |idx|
          v = @puzzle.grid[idx]

          if idx != pos
            if v == val
              return false
            end
            if v == 0
              empty_cell = true
            end
          end

          sum += v
        end

        unless (sum == g.sum and not empty_cell) or
            (empty_cell and sum < g.sum)

          return false
        end
      end

      true
    end
  end
end
