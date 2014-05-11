# encoding: utf-8
require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

describe Enumerable do

  describe ":merge_enum Method" do
    it "Enumerable" do
      enm_1 = 0...100
      enum = enm_1.to_a.merge_enum(
        first: 200
      )
      expect(enum.count).to be 100

      enum_2 = MergeEnum::MergeEnumerable.new(
        enm_1,
        first: 200
      )
      expect(enum.to_a).to eq(enum_2.to_a)
    end
    it "Enumerable, Proc, Lambda" do
      enm_1 = 0...100
      enm_2 = -> (c) { arg1 = c; 200...250 }
      enm_3 = Proc.new { |c| arg2 = c; 300...330 }
      enum = enm_1.to_a.merge_enum(
        enm_2, enm_3,
        first: 200
      )
      expect(enum.count).to be 180

      enum_2 = MergeEnum::MergeEnumerable.new(
        enm_1, enm_2, enm_3,
        first: 200
      )
      expect(enum.to_a).to eq(enum_2.to_a)
    end
  end

end

