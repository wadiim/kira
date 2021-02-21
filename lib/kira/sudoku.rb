# -*- coding: utf-8 -*-

require 'kira/group'
require 'kira/puzzle'

module Kira

  # A Killer Sudoku solver. It is initialized with an optional string
  # containing a grid followed by any number of equations. The grid consists
  # of digits from 1 to 9 and dots representing an empty cell. Each equation
  # has to be on its own line.
  class Sudoku
    def initialize(string)
      grid = ""
      @groups = []
      string.each_line do |line|
        if line.match("^[1-9\. \t\n\r]*$")
          grid << line
        else
          @groups.push(Group.new(line))
        end
      end

      if grid == ""
        grid << '.' * 81
      end

      @puzzle = Puzzle.new(grid)

      # '@grid_of_group_idxs' maps the cell's index to the index of the group
      # to which the cell belongs.
      @grid_of_group_idxs = Array.new(81)
      0.upto(@groups.size - 1) do |i|
        @groups[i].indexes.each { |j| @grid_of_group_idxs[j] = i }
      end
    end

    attr_reader :puzzle, :groups, :grid_of_group_idxs

    def to_s
      @puzzle.to_s
    end

    def solve(start = 0)
      # Find next empty cell.
      until @puzzle[start] == 0 or @puzzle[start] == nil
        start += 1
      end

      if @puzzle[start] == nil
        return true
      end

      possibilities = []
      1.upto(9) do |v|
        if valid?(v, start)
          possibilities.push(v)
        end
      end

      possibilities.each do |p|
        @puzzle[start] = p

        if solve(start + 1)
          return true
        end
      end

      @puzzle[start] = 0
      false
    end

    # Returns true if the 'val' on the given 'pos' does not repeat in a column,
    # row, box or group and all the equations are satisfied.
    def valid?(val, pos)
      unless @puzzle.valid?(val, pos)
        return false
      end

      group_idx = @grid_of_group_idxs[pos]
      if group_idx == nil
        return true
      end

      g = @groups[group_idx]
      sum = val

      # Set to true when the group contains an empty cell at position other
      # than 'pos'.
      empty = false

      g.indexes.each do |idx|
        v = @puzzle.grid[idx]

        if idx != pos
          if v == val
            return false
          end
          if v == 0
            empty = true
          end
        end

        sum += v
      end

      unless (sum == g.sum and not empty) or (empty and sum < g.sum)
        return false
      end

      true
    end
  end
end
