# -*- coding: utf-8 -*-

module Kira

  # Represents the state of a 9x9 sudoku puzzle. 
  class Puzzle
    def initialize(grid)
      grid.delete!(" \t\n\r")

      if grid.length != 81
        raise ArgumentError.new("Grid has invalid size")
      elsif not grid.match("^[0-9.]{81}$")
        raise ArgumentError.new("Grid contains invalid characters")
      end

      @grid = []
      grid.each_char { |c| @grid.push(c.to_i) }

      @gaps = 0
      @grid.each do |cell|
        if cell == 0
          @gaps += 1
        end
      end
    end

    attr_reader :grid, :grid_of_possibilities, :gaps

    # Traverses the row, column, and box containing the 'pos' and call the
    # 'proc' with the current index as an argument on each step. Note that it
    # visits some cells more than once.
    def scan(pos, &proc)
      # pos - (pos % 9):
      #   index of the first cell in the row containing 'pos'.
      #
      # pos % 9:
      #   index of the first cell in the column containing 'pos'.
      #
      # (pos - (pos % 3)):
      #   index of the left-most cell in the box containing 'pos'.
      #
      # (pos - (pos % 3)) % 9:
      #   index of the first cell in the column containing the top-left corner
      #   of the box.
      #
      # (pos - (pos % 27)):
      #   index of the first cell in the row containing the top-left corner of
      #   the box.
      #
      # (pos - (pos % 3)) % 9 + (pos - (pos % 27)):
      #   index of the top-left corner of the box containing 'pos'.

      # Scan row
      9.times do |i|
        proc.call((pos - (pos % 9)) + i)
      end

      # Scan col
      9.times do |i|
        proc.call((pos % 9) + i*9)
      end

      # Scan box
      corner_idx = (pos - (pos % 3)) % 9 + (pos - (pos % 27))
      3.times do |i|
        3.times do |j|
          proc.call(corner_idx + i*9 + j)
        end
      end
    end

    alias :update :scan 

    # Returns true if the 'val' on the given 'pos' does not repeat in a column,
    # row or box. The 'pos' is a 1-dimensional, 0-based index.
    def valid?(val, pos)
      if val != 0
        scan(pos) { |i| if val == @grid[i] then return false end }
      end
      true
    end

    def to_s
      string = ""
      0.upto(80) do |i|
        if @grid[i] == 0
          string << "."
        else
          string << @grid[i].to_s
        end
        if ((i + 1) % 9 == 0 and i != 80)
          string << "\n"
        end
      end

      string
    end

    def solved?
      @gaps == 0
    end

    def [](idx)
      @grid[idx]
    end

    def []=(idx, val)
      if idx > 80
        raise IndexError.new("Index out of range")
      elsif not val.between?(0, 9)
        raise ArgumentError.new("Value out of range")
      end

      old = @grid[idx]
      @grid[idx] = val

      if val != 0 and old == 0
        @gaps -= 1
      elsif val == 0 and old != 0
        @gaps += 1
      end
    end
  end
end
