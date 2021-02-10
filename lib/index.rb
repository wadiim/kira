# -*- coding: utf-8 -*-

module Kira

  # Represents a 2-dimensional, 0-based index of a cell in the Sudoku puzzle.
  class Index
    def initialize(row, col)
      unless row.between?(0, 8) and col.between?(0, 8)
        raise ArgumentError.new("Index out of range")
      end

      @row, @col = row, col
    end

    attr_reader :row, :col

    def to_s
      "(#@row, #@col)"
    end

    def ==(other)
      self.row == other.row and self.col == other.col
    end
  end
end
