# -*- coding: utf-8 -*-

require './lib/group'

RSpec.describe Kira::Group do
  before(:each) do
    @sum = 22
    @idxs = []
    3.times { |i| @idxs[i] = Kira::Index.new(i, i) }
    @test_attrs = Proc.new {
      |group|
      expect(group.sum).to eq(@sum)
      expect(group.indexes).to match_array(@idxs)
    }
  end
    
  describe "#initialize" do
    context "given a string argument in the correct format" do
      it "sets the 'sum' and 'indexes' instance variables" do
        group = Kira::Group.new("#{@idxs[0]}+#{@idxs[1]}+#{@idxs[2]}=#{@sum}")
        @test_attrs.call(group)
      end
    end

    context "given a string with extra whitespace characters" do
      it "removes them" do
        group = Kira::Group.new(" #{@idxs[0]}\t+ "\
                                " #{@idxs[1]}\n +"\
                                "\n#{@idxs[2]}\t "\
                                "   \n= #{@sum}\n")
        @test_attrs.call(group)
      end
    end

    context "given a string argument in an invalid format" do
      it "raises ArgumentError" do
        expect { Kira::Group.new("2+2=4") }.to raise_error(ArgumentError)
      end
    end
  end
end
