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

    context "given an arg which duplicates a value in other equation" do
      it "returns true" do
        sudoku = Kira::Sudoku.new("5.67..34.\n"\
                                  "492.35718\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  "8.......2\n"\
                                  "(0,0)+(0,1)+(0,2)+(0,3)=26\n"\
                                  "(1,0)+(1,1)+(1,2)+(1,3)=21\n")

        expect(sudoku.valid?(6, 12)).to eq(true)
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

      context "and some equations" do
        it "solves it" do
          sudoku = Kira::Sudoku.new(@grid + "\n" +
                                    "(0,0)+(0,1)+(0,2)+(0,3)=26\n" +
                                    "(0,4)+(0,5)+(0,6)+(0,7)=17\n")
          sudoku.solve
          expect(sudoku.puzzle.to_s).to eq(@solved_grid)
        end
      end
    end

    context "given an empty grid and equations" do
      it "solves it" do
        sudoku = Kira::Sudoku.new(".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  ".........\n"\
                                  "(0,0)=1\n"\
                                  "(1,0)=3\n"\
                                  "(0,1)+(0,2)=10\n"\
                                  "(0,3)+(0,4)=9\n"\
                                  "(0,5)+(1,5)=12\n"\
                                  "(0,6)=6\n"\
                                  "(1,6)=5\n"\
                                  "(0,7)+(0,8)=16\n"\
                                  "(1,1)+(1,2)+(2,1)=17\n"\
                                  "(2,0)+(3,0)=13\n"\
                                  "(2,2)+(2,3)=11\n"\
                                  "(1,3)+(1,4)=15\n"\
                                  "(2,4)+(3,4)=9\n"\
                                  "(2,5)+(3,5)=5\n"\
                                  "(1,7)+(1,8)+(2,7)=6\n"\
                                  "(2,6)+(3,6)=13\n"\
                                  "(3,7)=2\n"\
                                  "(2,8)+(3,8)+(4,8)=17\n"\
                                  "(3,1)+(3,2)+(4,2)=13\n"\
                                  "(4,0)+(4,1)=5\n"\
                                  "(5,0)+(5,1)=15\n"\
                                  "(5,2)+(5,3)=11\n"\
                                  "(3,3)+(4,3)=7\n"\
                                  "(4,4)+(5,4)+(6,4)=12\n"\
                                  "(4,5)+(4,6)+(5,5)=20\n"\
                                  "(5,6)+(6,6)+(6,7)=10\n"\
                                  "(4,7)+(5,7)+(5,8)=15\n"\
                                  "(6,0)=7\n"\
                                  "(7,0)=6\n"\
                                  "(7,1)=5\n"\
                                  "(6,1)+(6,2)=17\n"\
                                  "(8,0)+(8,1)+(8,2)=7\n"\
                                  "(6,3)+(7,3)+(7,2)=16\n"\
                                  "(8,3)+(8,4)=8\n"\
                                  "(7,4)+(7,5)+(6,5)=16\n"\
                                  "(8,5)+(8,6)+(8,7)=24\n"\
                                  "(7,6)+(7,7)=5\n"\
                                  "(6,8)+(7,8)=10\n"\
                                  "(8,8)=6\n")
        sudoku.solve
        expect(sudoku.puzzle.to_s).to eq("182543679\n"\
                                         "346879512\n"\
                                         "579261438\n"\
                                         "817634925\n"\
                                         "235198764\n"\
                                         "964725381\n"\
                                         "798416253\n"\
                                         "653982147\n"\
                                         "421357896")
      end
    end
  end
end
