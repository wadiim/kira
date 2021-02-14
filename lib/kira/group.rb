# -*- coding: utf-8 -*-

module Kira

  # Represents a group of cells, the sum of which must be equal to a certain
  # fixed number. It is initialized with an equation having the following form
  # (whitespaces are ignored):
  #   (r1, c1) + (r2, c2) + ... = s
  # where:
  #   rn - row number
  #   cn - column number
  #   s - sum of the values at the given indexes 
  class Group
    def initialize(equation)
      equation.delete!(" \t\n\r")

      unless equation.match /(\(\d,\d\)+)*\(\d,\d\)=\d+/
        raise ArgumentError.new("Equation has invalid format")
      end

      *str_idxs, @sum = equation.split(/[=+]/)
      @sum = @sum.to_i
      @indexes = []
      str_idxs.each {
        |idx|
        row, col = idx.scan(/\d+/).map(&:to_i)
        indexes.push(row*9 + col)
      }
    end

    attr_reader :indexes, :sum

    def to_s
      (@indexes.map { |i| "(#{i/9}, #{i%9})" }).join(" + ") + " = #{@sum}"
    end
  end
end
