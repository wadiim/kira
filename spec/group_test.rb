# -*- coding: utf-8 -*-

require 'kira/group'

RSpec.describe Kira::Group do
  describe "#initialize" do
    context "given a string in the correct format" do
      it "initializes the 'sum' and 'indexes' instance variables" do
        group = Kira::Group.new("(2,2)+(4,8)+(7,2)=22")
        expect(group.indexes).to match_array([20, 44, 65])
        expect(group.sum).to eq(22)
      end
    end

    context "given a string with extra whitespace characters" do
      it "ignores them" do
        group = Kira::Group.new(" ( 0  , 1\n)\t+ "\
                                " \t(1,  \t0)\n +"\
                                "\n(\t2\t,\t2)\t "\
                                "   \n\t= \t 18\n")
        expect(group.indexes).to match_array([1, 9, 20])
        expect(group.sum).to eq(18)
      end
    end

    context "given a string in an invalid format" do
      it "raises ArgumentError" do
        expect { Kira::Group.new("2+2=4") }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#to_s" do
    it "returns a string representation of the group" do
      equation = "(2, 2) + (1, 8) + (4, 4) = 20"
      group = Kira::Group.new(equation.dup)
      expect(group.to_s).to eq(equation)
    end
  end
end
