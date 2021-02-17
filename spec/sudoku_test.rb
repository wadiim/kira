# -*- coding: utf-8 -*-

require 'kira/sudoku'

RSpec.describe Kira::Sudoku do
  before(:each) do
    @grid =
      "5.67..34.\n"\
      "492.35718\n"\
      "3.78...69\n"\
      "..9281.7.\n"\
      "7..9562..\n"\
      "2.14.389.\n"\
      "9...67..3\n"\
      ".7..9.6.4\n"\
      ".6534.927"

    @solved_grid =
      "586719342\n"\
      "492635718\n"\
      "317824569\n"\
      "639281475\n"\
      "748956231\n"\
      "251473896\n"\
      "924567183\n"\
      "873192654\n"\
      "165348927"

    @empty_grid =
      ".........\n"\
      ".........\n"\
      ".........\n"\
      ".........\n"\
      ".........\n"\
      ".........\n"\
      ".........\n"\
      ".........\n"\
      "........."
  end

  describe "#initialize" do
    context "given a valid grid" do
      it "initializes the 'puzzle' instance variable" do
        sudoku = Kira::Sudoku.new(@grid.dup)
        expect(sudoku.puzzle.to_s).to eq(@grid)
      end
    end

    context "when no grid was given" do
      it "creates an empty grid" do
        sudoku = Kira::Sudoku.new("")
        expect(sudoku.puzzle.to_s).to eq(@empty_grid)
      end
    end

    context "given an equation" do
      it "initializes the 'groups' instance variable" do
        equation = "(2, 1) + (3, 2) + (4, 8) = 12"
        sudoku = Kira::Sudoku.new(@grid + "\n" + equation + "\n")
        expect(sudoku.groups[0].to_s).to eq(equation)
      end
    end

    context "given a string containing empty lines" do
      it "ignores them" do
        sudoku = Kira::Sudoku.new("\n\n5.67..34.\n" \
                                  "492.35718\n"     \
                                  "3.78...69\n"     \
                                  "..9281.7.\n\n"   \
                                  "7..9562..\n"     \
                                  "2.14.\n\n389.\n" \
                                  "9...67..3\n"     \
                                  ".7..9.6.4\n"     \
                                  ".6534.927\n\n")
        expect(sudoku.puzzle.to_s).to eq(@grid)
        expect(sudoku.groups.size).to eq(0)
      end
    end
  end

  describe "#to_s" do
   it "returns a multiline string representation of the sudoku" do
     sudoku = Kira::Sudoku.new(@grid.dup)
     expect(sudoku.to_s).to eq(@grid)
   end 
  end

  describe "#valid?" do
    context "given arguments which unsatisfy the equation" do
      it "returns false" do
        @empty_grid[0, 3] = "137"
        sudoku = Kira::Sudoku.new(@empty_grid + "\n" +
                                  "(0,0)+(0,1)+(0,2)+(0,3)=22\n")
        expect(sudoku.valid?(2, 3)).to eq(false)
      end
    end

    context "given arguments which satisfy the equation" do
      it "returns true" do
        @empty_grid[10] = '1'
        @empty_grid[20] = '2'
        @empty_grid[30] = '3'
        @empty_grid[40] = '4'
        sudoku = Kira::Sudoku.new(@empty_grid + "\n" +
                                  "(0,0)+(1,0)+(2,0)+(3,0)+(4,0)=15\n")
        expect(sudoku.valid?(5, 0)).to eq(true)
      end
    end

    context "given a duplicate of other value in the equation" do
      it "returns false" do
        @empty_grid[7] = '3'
        @empty_grid[8] = '4'
        @empty_grid[80] = '8'
        @empty_grid[88] = '2'
        sudoku = Kira::Sudoku.new(@empty_grid + "\n" +
                                  "(0,0)+(0,7)+(0,8)+(8,0)+(8,8)=19\n")
        expect(sudoku.valid?(2, 0)).to eq(false)
      end
    end

    context "given a duplicate of a value in other equation" do
      it "returns true" do
        @empty_grid[0, 19] = "5.67..34.\n492.35718"
        sudoku = Kira::Sudoku.new(@empty_grid + "\n" +
                                  "(0,0)+(0,1)+(0,2)+(0,3)=26\n" +
                                  "(1,0)+(1,1)+(1,2)+(1,3)=21\n")
        expect(sudoku.valid?(6, 12)).to eq(true)
      end
    end

    context "given an equation containing multiple empty cells" do
      before(:each) do
        @empty_grid[0, 3] = "1.3"
      end

      context "given a sum greater than the current one" do
        it "returns true" do
          sudoku = Kira::Sudoku.new(@empty_grid + "\n" +
                                    "(0,0)+(0,1)+(0,2)+(0,3)+(0,4)=26\n")
          expect(sudoku.valid?(2, 1)).to eq(true)
        end
      end

      context "given a sum less than the current one" do
        it "returns false" do
          sudoku = Kira::Sudoku.new(@empty_grid + "\n" +
                                    "(0,0)+(0,1)+(0,2)+(0,3)+(0,4)=3\n")
          expect(sudoku.valid?(8, 1)).to eq(false)
        end
      end

      context "given a sum equal to the current one" do
        it "returns false" do
          sudoku = Kira::Sudoku.new(@empty_grid + "\n" +
                                    "(0,0)+(0,1)+(0,2)+(0,3)+(0,4)=6\n")
          expect(sudoku.valid?(2, 1)).to eq(false)
        end
      end
    end
  end

  describe "#solve" do
    context "given a solved grid" do
      it "returns true" do
        sudoku = Kira::Sudoku.new(@solved_grid)
        expect(sudoku.solve).to eq(true)
      end
    end

    context "given an over-constrained grid" do
      it "returns false" do
        @grid[0] = '8'
        sudoku = Kira::Sudoku.new(@grid)
        expect(sudoku.solve).to eq(false)
      end
    end
  end
end
