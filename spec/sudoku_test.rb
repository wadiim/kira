# -*- coding: utf-8 -*-

require 'sudoku'

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
  end

  describe "#initialize" do
    context "given a grid" do
      it "initializes the 'puzzle' instance variable" do
        sudoku = Kira::Sudoku.new(@grid)
        expect(sudoku.puzzle.to_s).to eq(@grid)
      end
    end

    context "given expressions" do
      it "initializes the 'groups' instance variable" do
        groups = [Kira::Group.new("(2,1)+(3,2)+(4,8)=12"),
                  Kira::Group.new("(1,1)+(7,2)+(5,6)=9")]
        sudoku = Kira::Sudoku.new(@grid + "\n" +
                                  groups[0].to_s + "\n" +
                                  groups[1].to_s + "\n")
        expect(sudoku.groups[0].to_s).to eq(groups[0].to_s)
        expect(sudoku.groups[1].to_s).to eq(groups[1].to_s)
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
     sudoku = Kira::Sudoku.new(@grid)
     expect(sudoku.to_s).to eq(@grid)
   end 
  end

  describe "#valid?" do
    context "given arguments which unsatisfy the equation" do
      it "returns false" do
        sudoku = Kira::Sudoku.new("137......\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  "(0,0)+(0,1)+(0,2)+(0,3)=22\n")
        expect(sudoku.valid?(2, 3)).to eq(false)
      end
    end

    context "given arguments which satisfy the equation" do
      it "returns true" do
        sudoku = Kira::Sudoku.new(".........\n"\
                                  "1........\n"\
                                  "2........\n"\
                                  "3........\n"\
                                  "4........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  "(0,0)+(1,0)+(2,0)+(3,0)+(4,0)=15\n")
        expect(sudoku.valid?(5, 0)).to eq(true)
      end
    end

    context "given an arg which duplicates other value in the equation" do
      it "returns false" do
        sudoku = Kira::Sudoku.new(".......34\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  "8.......2\n"\
                                  "(0,0)+(0,7)+(0,8)+(8,0)+(8,8)=19\n")
        expect(sudoku.valid?(2, 0)).to eq(false)
      end
    end

    context "given an equation containing multiple empty cells" do
      before(:each) do
        @g = "1.3......\n"\
             ".........\n"\
             ".........\n"\
             ".........\n"\
             ".........\n"\
             ".........\n"\
             ".........\n"\
             ".........\n"\
             ".........\n"\
      end

      context "given a sum greater than the current one" do
        it "returns true" do
          sudoku = Kira::Sudoku.new(@g + "(0,0)+(0,1)+(0,2)+(0,3)+(0,4)=26\n")
          expect(sudoku.valid?(2, 1)).to eq(true)
        end
      end

      context "given a sum less than the current one" do
        it "returns false" do
          sudoku = Kira::Sudoku.new(@g + "(0,0)+(0,1)+(0,2)+(0,3)+(0,4)=3\n")
          expect(sudoku.valid?(8, 1)).to eq(false)
        end
      end

      context "given a sum equal to the current one" do
        it "returns false" do
          sudoku = Kira::Sudoku.new(@g + "(0,0)+(0,1)+(0,2)+(0,3)+(0,4)=6\n")
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

    context "given an unsolved grid" do
      it "solves it" do
        sudoku = Kira::Sudoku.new(@grid)
        sudoku.solve
        expect(sudoku.puzzle.to_s).to eq(@solved_grid)
      end
    end
  end
end
