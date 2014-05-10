# -*- encoding: UTF-8 -*-
require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

describe MergeEnum::MergeEnumerable do

  describe "No Arguments to MergeEnumerable" do
    it "count" do
      enum = MergeEnum::MergeEnumerable.new
      expect(enum.count).to be 0
    end
    it "option_first" do
      enum = MergeEnum::MergeEnumerable.new first: 50
      expect(enum.count).to be 0
    end
    it "option_first negative" do
      enum = MergeEnum::MergeEnumerable.new first: -50
      expect(enum.count).to be 0
    end
    it "option_first nil" do
      enum = MergeEnum::MergeEnumerable.new first: nil
      expect(enum.count).to be 0
    end
    it "option_first false" do
      enum = MergeEnum::MergeEnumerable.new first: false
      expect(enum.count).to be 0
    end
    it "option_first true" do
      enum = MergeEnum::MergeEnumerable.new first: true
      expect(enum.count).to be 0
    end
    it "option_first illegal" do
      enum = MergeEnum::MergeEnumerable.new first: "hoge"
      expect(enum.count).to be 0
    end
  end

  describe "Empty Array to MergeEnumerable" do
    it "count" do
      enum = MergeEnum::MergeEnumerable.new []
      expect(enum.count).to be 0
    end
    it "option_first" do
      enum = MergeEnum::MergeEnumerable.new [], first: 50
      expect(enum.count).to be 0
    end
    it "option_first negative" do
      enum = MergeEnum::MergeEnumerable.new [], first: -50
      expect(enum.count).to be 0
    end
    it "option_first nil" do
      enum = MergeEnum::MergeEnumerable.new [], first: nil
      expect(enum.count).to be 0
    end
    it "option_first false" do
      enum = MergeEnum::MergeEnumerable.new [], first: false
      expect(enum.count).to be 0
    end
    it "option_first true" do
      enum = MergeEnum::MergeEnumerable.new [], first: true
      expect{ enum.count }.to raise_error NoMethodError
    end
    it "option_first illegal" do
      enum = MergeEnum::MergeEnumerable.new [], first: "hoge"
      expect{ enum.count }.to raise_error NoMethodError
    end
  end

  describe "Illegal Argument to MergeEnumerable" do
    it "illegal argument" do
      enum = MergeEnum::MergeEnumerable.new "hoge"
      expect{ enum.count }.to raise_error NoMethodError
    end
  end

  describe "One Enumerable to MergeEnumerable" do
    it "count" do
      enum = MergeEnum::MergeEnumerable.new 0...100
      expect(enum.count).to be 100
    end
    it "option_first limited" do
      enum = MergeEnum::MergeEnumerable.new 0...100, first: 50
      expect(enum.count).to be 50
    end
    it "option_first over" do
      enum = MergeEnum::MergeEnumerable.new 0...100, first: 200
      expect(enum.count).to be 100
    end
  end

  describe "Two Enumerables to MergeEnumerable" do
    it "count" do
      enum = MergeEnum::MergeEnumerable.new 0...100, 200...250
      expect(enum.count).to be 150
    end
    it "option_first limited at first" do
      enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, first: 50
      expect(enum.count).to be 50
    end
    it "option_first limited at second" do
      enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, first: 130
      expect(enum.count).to be 130
    end
    it "option_first over" do
      enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, first: 200
      expect(enum.count).to be 150
    end
  end

  describe "Three Enumerables to MergeEnumerable" do
    it "count" do
      enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, 300...330
      expect(enum.count).to be 180
    end
    it "option_first limited at first" do
      enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, 300...330, first: 50
      expect(enum.count).to be 50
    end
    it "option_first limited at second" do
      enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, 300...330, first: 130
      expect(enum.count).to be 130
    end
    it "option_first limited at third" do
      enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, 300...330, first: 170
      expect(enum.count).to be 170
    end
    it "option_first over" do
      enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, 300...330, first: 200
      expect(enum.count).to be 180
    end
  end

  describe "Lambda to MergeEnumerable" do
    it "option_first limited at first" do
      enum = MergeEnum::MergeEnumerable.new(
        -> { 0...100 },
        -> { 200...250 },
        first: 50
      )
      expect(enum.count).to be 50
    end
    it "option_first over" do
      enum = MergeEnum::MergeEnumerable.new(
        -> { 0...100 },
        -> { 200...250 },
        first: 200
      )
      expect(enum.count).to be 150
    end
  end

  describe "Lambda with Arguments to MergeEnumerable" do
    it "option_first limited at first" do
      arg1, arg2 = nil, nil
      enum = MergeEnum::MergeEnumerable.new(
        -> (c) { arg1 = c; 0...100 },
        -> (c) { raise "unexpect"; 200...250 },
        first: 50
      )
      expect(enum.count).to be 50
      expect(arg1).to be 50
      expect(arg2).to be_nil
    end
    it "option_first over" do
      arg1, arg2 = nil, nil
      enum = MergeEnum::MergeEnumerable.new(
        -> (c) { arg1 = c; 0...100 },
        -> (c) { arg2 = c; 200...250 },
        first: 200
      )
      expect(enum.count).to be 150
      expect(arg1).to be 200
      expect(arg2).to be 100
    end
  end

  describe "Proc to MergeEnumerable" do
    it "option_first limited at first" do
      enum = MergeEnum::MergeEnumerable.new(
        Proc.new { 0...100 },
        Proc.new { 200...250 },
        first: 50
      )
      expect(enum.count).to be 50
    end
    it "option_first over" do
      enum = MergeEnum::MergeEnumerable.new(
        Proc.new { 0...100 },
        Proc.new { 200...250 },
        first: 200
      )
      expect(enum.count).to be 150
    end
  end

  describe "Proc with Arguments to MergeEnumerable" do
    it "option_first limited at first" do
      arg1, arg2 = nil, nil
      enum = MergeEnum::MergeEnumerable.new(
        Proc.new { |c| arg1 = c; 0...100 },
        Proc.new { |c| raise "unexpect"; 200...250 },
        first: 50
      )
      expect(enum.count).to be 50
      expect(arg1).to be 50
      expect(arg2).to be_nil
    end
    it "option_first over" do
      arg1, arg2 = nil, nil
      enum = MergeEnum::MergeEnumerable.new(
        Proc.new { |c| arg1 = c; 0...100 },
        Proc.new { |c| arg2 = c; 200...250 },
        first: 200
      )
      expect(enum.count).to be 150
      expect(arg1).to be 200
      expect(arg2).to be 100
    end
  end

  describe "Complex Enumerables to MergeEnumerable" do
    it "Enumerable, Proc, Lambda" do
      arg1, arg2 = nil, nil
      enum = MergeEnum::MergeEnumerable.new(
        0...100,
        -> (c) { arg1 = c; 200...250 },
        Proc.new { |c| arg2 = c; 300...330 },
        first: 200
      )
      expect(enum.count).to be 180
      expect(arg1).to be 100
      expect(arg2).to be 50
    end
    it "Proc, Lambda, Enumerable" do
      arg1, arg2 = nil, nil
      enum = MergeEnum::MergeEnumerable.new(
        -> (c) { arg1 = c; 0...100 },
        Proc.new { |c| arg2 = c; 200...250 },
        300...330,
        first: 200
      )
      expect(enum.count).to be 180
      expect(arg1).to be 200
      expect(arg2).to be 100
    end
  end

  describe "Equality Enumerator" do
    it "equality enumerator" do
      enum = MergeEnum::MergeEnumerable.new(
        0...100,
        -> (c) { arg1 = c; 200...250 },
        Proc.new { |c| arg2 = c; 300...330 },
        first: 200
      )
      enum_sub = enum.each
      expect(enum_sub).not_to be(enum)
      expect(enum_sub.to_a).to eq(enum.to_a)
    end
  end

  describe "Whitebox" do
    it "call first method" do
      ary = (0...100)
      enum = MergeEnum::MergeEnumerable.new(
        ary,
        -> (c) { arg1 = c; 200...250 },
        Proc.new { |c| arg2 = c; 300...330 },
        first: 200
      )
      expect(ary).to receive(:first).with(200).and_return(ary)
      expect(enum.count).to be 180
    end
  end

end

