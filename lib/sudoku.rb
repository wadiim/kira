# -*- coding: utf-8 -*-

require 'puzzle'

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

      # If there is no value to insert, return false.
      if min_idx == 0 and @puzzle[min_idx] != 0 or
          @puzzle.grid_of_possibilities[min_idx] == 0

        return false
      end

      @puzzle.grid_of_possibilities[min_idx].each do
        |v|
        unless valid?(v, min_idx)
          next
        end

        @puzzle[min_idx] = v

        if solve()
          return true
        end
      end

      false
    end

    # Returns true if the 'val' on the given 'pos' does not repeat in a column,
    # row, box or group and all the equations are satisfied.
    def valid?(val, pos)
      if not @puzzle.valid?(val, pos)
        return false
      end

      @groups.each do
        |g|
        sum = 0
        g.indexes.each do
          |idx|
          flattened_idx = idx.row*9 + idx.col
          # If the group contains the 'pos', take its value into account when
          # calculating the 'sum'.
          if flattened_idx == pos
            sum += val
          else
            v = @puzzle.grid[flattened_idx]
            # If the group already contains that value, return false.
            if val == v
              return false
            end
            sum += v
          end
        end

        if sum != g.sum
          return false
        end
      end

      true
    end
  end
end
