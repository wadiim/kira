# -*- coding: utf-8 -*-

require 'kira/puzzle'

RSpec.describe Kira::Puzzle do
  before(:each) do
    @grid_str =
      "5.67..34."\
      "492.35718"\
      "3.78...69"\
      "..9281.7."\
      "7..9562.."\
      "2.14.389."\
      "9...67..3"\
      ".7..9.6.4"\
      ".6534.927"

    @grid_multiline_str =
      "5.67..34.\n"\
      "492.35718\n"\
      "3.78...69\n"\
      "..9281.7.\n"\
      "7..9562..\n"\
      "2.14.389.\n"\
      "9...67..3\n"\
      ".7..9.6.4\n"\
      ".6534.927"

    @grid_arr =
      [5,0,6,7,0,0,3,4,0,
       4,9,2,0,3,5,7,1,8,
       3,0,7,8,0,0,0,6,9,
       0,0,9,2,8,1,0,7,0,
       7,0,0,9,5,6,2,0,0,
       2,0,1,4,0,3,8,9,0,
       9,0,0,0,6,7,0,0,3,
       0,7,0,0,9,0,6,0,4,
       0,6,5,3,4,0,9,2,7]

    @solved_grid_str =
      "586719342"\
      "492635718"\
      "317824569"\
      "639281475"\
      "748956231"\
      "251473896"\
      "924567183"\
      "873192654"\
      "165348927"

    @solved_grid_arr =
      [5,8,6,7,1,9,3,4,2,
       4,9,2,6,3,5,7,1,8,
       3,1,7,8,2,4,5,6,9,
       6,3,9,2,8,1,4,7,5,
       7,4,8,9,5,6,2,3,1,
       2,5,1,4,7,3,8,9,6,
       9,2,4,5,6,7,1,8,3,
       8,7,3,1,9,2,6,5,4,
       1,6,5,3,4,8,9,2,7]

    @empty_grid_str =
      "........."\
      "........."\
      "........."\
      "........."\
      "........."\
      "........."\
      "........."\
      "........."\
      "........."
  end

  describe "#initialize" do
    context "given a grid with a length not equal to 81" do
      it "raises ArgumentError" do
        expect { Kira::Puzzle.new("3.14") }.to raise_error(ArgumentError)
      end
    end

    context "given a grid containing invalid characters" do
      it "raises ArgumentError" do
        expect {
          @grid_str[22] = '$'
          @grid_str[32] = 'x'
          Kira::Puzzle.new(@grid_str)
        }.to raise_error(ArgumentError)
      end
    end

    context "given valid grid" do
      it "sets the 'grid' instance variable" do
        puzzle = Kira::Puzzle.new(@solved_grid_str)
        expect(puzzle.grid).to match_array(@solved_grid_arr)
      end
    end

    context "given a grid containing dots" do
      it "replaces the dots by 0's" do
        puzzle = Kira::Puzzle.new(@grid_str)
        expect(puzzle.grid).to match_array(@grid_arr)
      end
    end

    context "given a grid containing whitespaces" do
      it "removes them" do
        grid =
          "  5 .\n\t\n6 7. .3 4.\n" \
          "49\t2.35   7 18\n"       \
          "3.78 . ..6  9"           \
          "..92\t81  .7."           \
          "7..95   62.."            \
          "2.1  4.389.\r"           \
          "9...6   7..3"            \
          ".7..9   .6.4"            \
          ".65\t \t3 4.  927"
        puzzle = Kira::Puzzle.new(grid)
        expect(puzzle.to_s).to eq(@grid_multiline_str)
      end
    end
  end

  describe "#valid?" do
    context "given a valid value at the given position" do
      it "returns true" do
        puzzle = Kira::Puzzle.new(@empty_grid_str)
        expect(puzzle.valid?(9, 2)).to eq(true)
      end
    end

    context "given a value that is repeated in the row" do
      it "returns false" do
        @empty_grid_str[12] = '2'
        puzzle = Kira::Puzzle.new(@empty_grid_str)
        expect(puzzle.valid?(2, 10)).to eq(false)
      end
    end

    context "given a value that is repeated in the column" do
      it "returns false" do
        @empty_grid_str[30] = '2'
        puzzle = Kira::Puzzle.new(@empty_grid_str)
        expect(puzzle.valid?(2, 3)).to eq(false)
      end
    end

    context "given a value that is repeated in the box" do
      it "returns false" do
        @empty_grid_str[20] = '2'
        puzzle = Kira::Puzzle.new(@empty_grid_str)
        expect(puzzle.valid?(2, 0)).to eq(false)
      end
    end

    context "given a valid value and an index of a non-empty cell" do
      it "returns true" do
        puzzle = Kira::Puzzle.new(@grid_str)
        expect(puzzle.valid?(1, 0)).to eq(true)
      end
    end
  end

  describe "#to_s" do
    it "returns a multiline string representation of the puzzle" do
      puzzle = Kira::Puzzle.new(@grid_str)
      expect(puzzle.to_s).to eq(@grid_multiline_str)
    end
  end

  describe "#[]" do
    context "given a valid index" do
      it "returns a value at that index" do
        puzzle = Kira::Puzzle.new(@grid_str)
        expect(puzzle[2]).to eq(@grid_str[2].to_i)
      end
    end

    context "given an invalid index" do
      it "returns nil" do
        puzzle = Kira::Puzzle.new(@grid_str)
        expect(puzzle[100]).to eq(nil)
      end
    end
  end

  describe "#[]=" do
    context "given an index out of range" do
      it "raises IndexError" do
        puzzle = Kira::Puzzle.new(@grid_str)
        expect { puzzle[100] = 2 }.to raise_error(IndexError)
      end
    end

    context "given a value out of range" do
      it "raises ArgumentError" do
        puzzle = Kira::Puzzle.new(@grid_str)
        expect { puzzle[1] = -2 }.to raise_error(ArgumentError)
      end 
    end

    context "given an index of an empty cell and a valid value" do
      it "inserts it" do
        puzzle = Kira::Puzzle.new(@grid_str)
        puzzle[1] = 1
        expect(puzzle[1]).to eq(1)
      end
    end

    context "given an index of a non-empty cell and a valid value" do
      it "replaces the old value by the new one" do
        puzzle = Kira::Puzzle.new(@grid_str)
        puzzle[0] = 1
        expect(puzzle[0]).to eq(1)
      end
    end
  end
end
