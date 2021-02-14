# -*- coding: utf-8 -*-

require 'kira/index'

RSpec.describe Kira::Index do
  before(:each) do
    @row, @col = 2, 7
    @index = Kira::Index.new(@row, @col)
  end

  describe "#initialize" do
    context "given valid arguments" do
      it "sets the 'row' and 'col' instance variables" do
        expect(@index.row).to eq(@row)
        expect(@index.col).to eq(@col)
      end
    end

    context "given arguments out of range" do
      it "raises an ArgumentError" do
        expect { Kira::Index.new(-1, 9) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#to_s" do
    it "returns a string in the following form: '(\#{row}, \#{col})'" do
      expect(@index.to_s).to eq("(#{@row}, #{@col})")
    end
  end

  describe "#==" do
    context "given equal indexes" do
      it "returns true" do
        idx1 = Kira::Index.new(@row, @col)
        idx2 = idx1.dup
        expect(idx1).to eq(idx2)
      end
    end
  end
end
