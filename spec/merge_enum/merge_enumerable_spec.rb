# -*- encoding: UTF-8 -*-
require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

describe MergeEnum::MergeEnumerable do

  describe "No Arguments to MergeEnumerable:" do
    it "count" do
      enum = MergeEnum::MergeEnumerable.new
      expect(enum.count).to be 0
    end

    describe "option_first is" do
      it "positive" do
        enum = MergeEnum::MergeEnumerable.new first: 50
        expect(enum.count).to be 0
      end
      it "negative" do
        enum = MergeEnum::MergeEnumerable.new first: -50
        expect(enum.count).to be 0
      end
      it "nil" do
        enum = MergeEnum::MergeEnumerable.new first: nil
        expect(enum.count).to be 0
      end
      it "false" do
        enum = MergeEnum::MergeEnumerable.new first: false
        expect(enum.count).to be 0
      end
      it "true" do
        enum = MergeEnum::MergeEnumerable.new first: true
        expect{ enum.count }.to raise_error NoMethodError
      end
      it "illegal" do
        enum = MergeEnum::MergeEnumerable.new first: "hoge"
        expect(enum.count).to be 0
      end
    end

    describe "option_compact is" do
      it "true" do
        enum = MergeEnum::MergeEnumerable.new compact: true
        expect(enum.count).to be 0
      end
      it "false" do
        enum = MergeEnum::MergeEnumerable.new compact: false
        expect(enum.count).to be 0
      end
      it "nil" do
        enum = MergeEnum::MergeEnumerable.new compact: nil
        expect(enum.count).to be 0
      end
      it "Proc" do
        enum = MergeEnum::MergeEnumerable.new compact: Proc.new {}
        expect(enum.count).to be 0
      end
      it "Lambda" do
        enum = MergeEnum::MergeEnumerable.new compact: -> {}
        expect(enum.count).to be 0
      end
    end
  end

  describe "Empty Array to MergeEnumerable:" do
    it "count" do
      enum = MergeEnum::MergeEnumerable.new []
      expect(enum.count).to be 0
    end

    describe "option_first" do
      it "positive" do
        enum = MergeEnum::MergeEnumerable.new [], first: 50
        expect(enum.count).to be 0
      end
      it "negative" do
        enum = MergeEnum::MergeEnumerable.new [], first: -50
        expect(enum.count).to be 0
      end
      it "nil" do
        enum = MergeEnum::MergeEnumerable.new [], first: nil
        expect(enum.count).to be 0
      end
      it "false" do
        enum = MergeEnum::MergeEnumerable.new [], first: false
        expect(enum.count).to be 0
      end
      it "true" do
        enum = MergeEnum::MergeEnumerable.new [], first: true
        expect{ enum.count }.to raise_error NoMethodError
      end
      it "with to_i" do
        enum = MergeEnum::MergeEnumerable.new 0...100, first: "hoge"
        expect(enum.count).to be 0
      end
      it "with to_i" do
        enum = MergeEnum::MergeEnumerable.new 0...100, first: "10hoge"
        expect(enum.count).to be 10
      end
    end

    describe "option_compact" do
      it "true" do
        enum = MergeEnum::MergeEnumerable.new [], compact: true
        expect(enum.count).to be 0
      end
      it "false" do
        enum = MergeEnum::MergeEnumerable.new [], compact: false
        expect(enum.count).to be 0
      end
      it "nil" do
        enum = MergeEnum::MergeEnumerable.new [], compact: nil
        expect(enum.count).to be 0
      end
      it "Proc" do
        enum = MergeEnum::MergeEnumerable.new [], compact: Proc.new {}
        expect(enum.count).to be 0
      end
      it "Lambda" do
        enum = MergeEnum::MergeEnumerable.new [], compact: -> {}
        expect(enum.count).to be 0
      end
    end
  end

  describe "Illegal Argument to MergeEnumerable:" do
    it "illegal argument" do
      enum = MergeEnum::MergeEnumerable.new "hoge"
      expect{ enum.count }.to raise_error NoMethodError
    end
  end

  describe "One Enumerable to MergeEnumerable:" do
    it "count" do
      enum = MergeEnum::MergeEnumerable.new 0...100
      expect(enum.count).to be 100
    end

    describe "option_first" do
      it "limited" do
        enum = MergeEnum::MergeEnumerable.new 0...100, first: 50
        expect(enum.count).to be 50
      end
      it "over" do
        enum = MergeEnum::MergeEnumerable.new 0...100, first: 200
        expect(enum.count).to be 100
      end
    end

    describe "option_compact" do
      it "true" do
        ary = (0...100).map { |e| e.odd? ? e : nil }
        expect(ary.compact.count).to be 50
        expect(ary.count).to be 100
        enum = MergeEnum::MergeEnumerable.new ary, compact: true
        expect(enum.count).to be 50
      end
      it "false" do
        ary = (0...100).map { |e| e.odd? ? e : nil }
        enum = MergeEnum::MergeEnumerable.new ary, compact: false
        expect(enum.count).to be 100
      end
      it "nil" do
        ary = (0...100).map { |e| e.odd? ? e : nil }
        enum = MergeEnum::MergeEnumerable.new ary, compact: nil
        expect(enum.count).to be 100
      end
      it "Proc with no args" do
        ary = (0...100).map { |e| e.odd? ? e : nil }
        _proc = Proc.new { true }
        enum = MergeEnum::MergeEnumerable.new ary, compact: _proc
        expect(enum.count).to be 0

        _proc = Proc.new { false }
        enum = MergeEnum::MergeEnumerable.new ary, compact: _proc
        expect(enum.count).to be 100
      end
      it "Proc with args" do
        ary = (0...100).map { |e| e.odd? ? e : nil }
        _proc = Proc.new { |e| e.nil? }
        enum = MergeEnum::MergeEnumerable.new ary, compact: _proc
        expect(enum.count).to be 50

        ary = 0...100
        _proc = Proc.new { |e| e < 30 }
        enum = MergeEnum::MergeEnumerable.new ary, compact: _proc
        expect(enum.count).to be 70
      end
      it "Lambda with no args" do
        ary = (0...100).map { |e| e.odd? ? e : nil }
        _proc = -> { true }
        enum = MergeEnum::MergeEnumerable.new ary, compact: _proc
        expect(enum.count).to be 0
        _proc = -> { false }
        enum = MergeEnum::MergeEnumerable.new ary, compact: _proc
        expect(enum.count).to be 100
      end
      it "Lambda with args" do
        ary = (0...100).map { |e| e.odd? ? e : nil }
        _proc = -> (e) { e.nil? }
        enum = MergeEnum::MergeEnumerable.new ary, compact: _proc
        expect(enum.count).to be 50

        ary = 0...100
        _proc = -> (e) { e < 30 }
        enum = MergeEnum::MergeEnumerable.new ary, compact: _proc
        expect(enum.count).to be 70
      end
      it "with option_first" do
        ary = (0...100).map { |e| e.odd? ? e : nil }
        _proc = -> (e) { e.nil? }
        enum = MergeEnum::MergeEnumerable.new ary, first: 30, compact: _proc
        expect(enum.count).to be 30

        enum = MergeEnum::MergeEnumerable.new ary, first: 60, compact: _proc
        expect(enum.count).to be 50
      end
    end
  end

  describe "Two Enumerables to MergeEnumerable:" do
    it "count" do
      enum = MergeEnum::MergeEnumerable.new 0...100, 200...250
      expect(enum.count).to be 150
    end

    describe "option_first" do
      it "limited at first" do
        enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, first: 50
        expect(enum.count).to be 50
      end
      it "limited at second" do
        enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, first: 130
        expect(enum.count).to be 130
      end
      it "over" do
        enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, first: 200
        expect(enum.count).to be 150
      end
    end
  end

  describe "Three Enumerables to MergeEnumerable:" do
    it "count" do
      enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, 300...330
      expect(enum.count).to be 180
    end

    describe "option_first" do
      it "limited at first" do
        enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, 300...330, first: 50
        expect(enum.count).to be 50
      end
      it "limited at second" do
        enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, 300...330, first: 130
        expect(enum.count).to be 130
      end
      it "limited at third" do
        enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, 300...330, first: 170
        expect(enum.count).to be 170
      end
      it "over" do
        enum = MergeEnum::MergeEnumerable.new 0...100, 200...250, 300...330, first: 200
        expect(enum.count).to be 180
      end
    end
  end

  describe "Lambda to MergeEnumerable:" do
    describe "option_first" do
      it "limited at first" do
        enum = MergeEnum::MergeEnumerable.new(
          -> { 0...100 },
          -> { 200...250 },
          first: 50
        )
        expect(enum.count).to be 50
      end
      it "over" do
        enum = MergeEnum::MergeEnumerable.new(
          -> { 0...100 },
          -> { 200...250 },
          first: 200
        )
        expect(enum.count).to be 150
      end
    end
  end

  describe "Lambda with Arguments to MergeEnumerable:" do
    describe "option_first" do
      it "limited at first" do
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
      it "over" do
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
  end

  describe "Proc to MergeEnumerable:" do
    describe "option_first" do
      it "limited at first" do
        enum = MergeEnum::MergeEnumerable.new(
          Proc.new { 0...100 },
          Proc.new { 200...250 },
          first: 50
        )
        expect(enum.count).to be 50
      end
      it "over" do
        enum = MergeEnum::MergeEnumerable.new(
          Proc.new { 0...100 },
          Proc.new { 200...250 },
          first: 200
        )
        expect(enum.count).to be 150
      end
    end
  end

  describe "Proc with Arguments to MergeEnumerable:" do
    describe "option_first" do
      it "limited at first" do
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
      it "over" do
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
  end

  describe "Complex Enumerables to MergeEnumerable:" do
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

  describe "Equality Enumerator:" do
    it "equality enumerator" do
      enum = MergeEnum::MergeEnumerable.new(
        0...100,
        -> (c) { 200...250 },
        Proc.new { |c| 300...330 },
        first: 200
      )
      enum_sub = enum.each
      expect(enum).to be_a(Enumerable)
      expect(enum_sub).to be_a(Enumerable)
      expect(enum_sub).not_to be(enum)
      expect(enum_sub.to_a).to eq(enum.to_a)
    end
  end

  describe "Whitebox:" do
    it "call `first` method" do
      ary_1 = 0...100
      ary_2 = 200...250
      ary_3 = 300...330
      enum = MergeEnum::MergeEnumerable.new(
        ary_1,
        -> (c) { ary_2 },
        Proc.new { ary_3 },
        first: 200
      )
      expect(ary_1).to receive(:first).with(200).and_return(ary_1)
      allow(ary_2).to receive(:first).and_raise("unexpected")
      expect(ary_3).to receive(:first).with(50).and_return(ary_3)
      expect(enum.count).to be 180
    end
    it "not call `first` method" do
      ary = 0...100
      allow(ary).to receive(:first).and_raise("unexpect")
      enum = MergeEnum::MergeEnumerable.new ary, first: 10, compact: true
      expect(enum.count).to be 10
    end
  end

  describe "`concat` Method:" do
    it "equality enumerator" do
      enm_1 = 0...100
      enm_2 = -> (c) { 200...250 }
      enm_3 = Proc.new { |c| 300...330 }
      enum = MergeEnum::MergeEnumerable.new(
        enm_1, enm_2,
        first: 130
      )
      expect(enum.concat enm_3).not_to be(enum)

      enum_2 = MergeEnum::MergeEnumerable.new(
        enm_1, enm_2, enm_3,
        first: 130
      )
      expect(enum.concat(enm_3).to_a).to eq(enum_2.to_a)
    end
  end

  describe "`concat!` Method:" do
    it "equality enumerator" do
      enm_1 = 0...100
      enm_2 = -> (c) { 200...250 }
      enm_3 = Proc.new { |c| 300...330 }
      enum = MergeEnum::MergeEnumerable.new(
        enm_1, enm_2,
        first: 130
      )
      expect(enum.concat! enm_3).to be(enum)

      enum = MergeEnum::MergeEnumerable.new(
        enm_1, enm_2,
        first: 130
      )

      enum_2 = MergeEnum::MergeEnumerable.new(
        enm_1, enm_2, enm_3,
        first: 130
      )
      expect(enum.concat!(enm_3).to_a).to eq(enum_2.to_a)
    end
  end

end

