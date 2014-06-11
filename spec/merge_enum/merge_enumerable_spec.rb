# -*- encoding: UTF-8 -*-
require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

describe MergeEnum::MergeEnumerable do

  Target = MergeEnum::MergeEnumerable

  def self.test_empty ctx, lt, options = {}
    test_all ctx, lt, [], options
  end

  def self.test_all ctx, lt, ary, options = {}
    test_equal ctx, lt, ary, options
    test_interrupt ctx, lt, ary, options
  end

  def self.test_equal ctx, lt, ary, options = {}
    line = options[:line]
    ctx.instance_eval do
      _line = line ? " <at:#{line}>" : ""
      context "#count#{_line}" do
        subject { send(lt).count }
        it { is_expected.to be ary.count }
      end
      context "#to_a#{_line}" do
        subject { send(lt).to_a }
        it { is_expected.to eq ary.to_a }
      end
    end
  end

  def self.test_interrupt ctx, lt, ary, options = {}
    line = options[:line]
    ctx.instance_eval do
      _line = line ? " <at:#{line}>" : ""
      context "#none?#{_line}" do
        subject { send(lt).none? }
        it { is_expected.to be ary.none? }
      end
      context "#any?#{_line}" do
        subject { send(lt).any? }
        it { is_expected.to be ary.any? }
      end
    end
  end

  def self.test_error ctx, lt, options = {}
    line = options[:line]
    ctx.instance_eval do
      _line = line ? " <at:#{line}>" : ""
      context "#count#{_line}" do
        subject { send(lt).count }
        it { expect{ is_expected }.to raise_error }
      end
      context "#to_a#{_line}" do
        subject { send(lt).to_a }
        it { expect{ is_expected }.to raise_error }
      end
      context "#none?#{_line}" do
        subject { send(lt).none? }
        it { expect{ is_expected }.to raise_error }
      end
      context "#any?#{_line}" do
        subject { send(lt).any? }
        it { expect{ is_expected }.to raise_error }
      end
    end
  end

  [nil, "hoge", "foo", "bar"].each do |val|
    describe ".new #{val.inspect}" do
      let(:enum) { Target.new val }
      test_error self, :enum, line: __LINE__
    end
  end

  describe ".new [], nil" do
    let(:enum) { Target.new [], nil }
    test_error self, :enum, line: __LINE__
  end

  describe ".new" do

    describe "{}" do
      let(:enum) { Target.new }

      test_empty self, :enum, line: __LINE__
    end

    describe "first:" do
      let(:enum) { Target.new first: first }

      describe "0" do
        let(:first) { 0 }
        subject { enum }

        test_empty self, :enum, line: __LINE__
      end

      context "<positive>" do
        [1, 2, 50].each do |val|
          describe "#{val.inspect}" do
            let(:first) { val }
            test_empty self, :enum, line: __LINE__
          end
        end
      end

      context "<negative>" do
        [-1, -2, -50].each do |val|
          describe "#{val.inspect}" do
            let(:first) { val }
            test_empty self, :enum, line: __LINE__
          end
        end
      end

      describe "nil" do
        let(:first) { nil }
        test_empty self, :enum, line: __LINE__
      end

      describe "false" do
        let(:first) { false }
        test_empty self, :enum, line: __LINE__
      end

      describe "true" do
        let(:first) { true }
        test_error self, :enum, line: __LINE__
      end

      context "<illegal>" do
        ["hoge", "foo", "bar"].each do |val|
          describe "#{val.inspect}" do
            let(:first) { val }
            test_empty self, :enum, line: __LINE__
          end
        end
      end
    end

    describe "compact:" do
      let(:enum) { Target.new compact: compact }

      describe "true" do
        let(:compact) { true }
        test_empty self, :enum, line: __LINE__
      end

      describe "false" do
        let(:compact) { false }
        test_empty self, :enum, line: __LINE__
      end

      describe "nil" do
        let(:compact) { nil }
        test_empty self, :enum, line: __LINE__
      end

      describe "Proc.new {}" do
        let(:compact) { Proc.new {} }
        test_empty self, :enum, line: __LINE__
      end

      describe "-> {}" do
        let(:compact) { -> {} }
        test_empty self, :enum, line: __LINE__
      end
    end

    describe "select:" do
      let(:enum) { Target.new select: select }

      describe "true" do
        let(:select) { true }
        test_error self, :enum, line: __LINE__
      end

      describe "false" do
        let(:select) { false }
        test_empty self, :enum, line: __LINE__
      end

      describe "nil" do
        let(:select) { nil }
        test_empty self, :enum, line: __LINE__
      end

      describe "Proc.new {}" do
        let(:select) { Proc.new {} }
        test_empty self, :enum, line: __LINE__
      end

      describe "-> {}" do
        let(:select) { -> {} }
        test_empty self, :enum, line: __LINE__
      end
    end
  end

  describe ".new []," do

    describe "{}" do
      let(:enum) { Target.new [], {} }

      test_empty self, :enum, line: __LINE__
    end

    describe "first:" do
      let(:enum) { Target.new [], first: first }

      describe "0" do
        let(:first) { 0 }
        test_empty self, :enum, line: __LINE__
      end

      context "<positive>" do
        [1, 2, 50].each do |val|
          describe "#{val.inspect}" do
            let(:first) { val }
            test_empty self, :enum, line: __LINE__
          end
        end
      end

      context "<negative>" do
        [-1, -2, -50].each do |val|
          describe "#{val.inspect}" do
            let(:first) { val }
            test_empty self, :enum, line: __LINE__
          end
        end
      end

      describe "nil" do
        let(:first) { nil }
        test_empty self, :enum, line: __LINE__
      end

      describe "false" do
        let(:first) { false }
        test_empty self, :enum, line: __LINE__
      end

      describe "true" do
        let(:first) { true }
        test_error self, :enum, line: __LINE__
      end

      context "<illegal>" do
        ["hoge", "foo", "bar"].each do |val|
          describe "#{val.inspect}" do
            let(:first) { val }
            test_empty self, :enum, line: __LINE__
          end
        end
      end
    end

    describe "compact:" do
      let(:enum) { Target.new [], compact: compact }

      describe "true" do
        let(:compact) { true }
        test_empty self, :enum, line: __LINE__
      end

      describe "false" do
        let(:compact) { false }
        test_empty self, :enum, line: __LINE__
      end

      describe "nil" do
        let(:compact) { nil }
        test_empty self, :enum, line: __LINE__
      end

      describe "Proc.new {}" do
        let(:compact) { Proc.new {} }
        test_empty self, :enum, line: __LINE__
      end

      describe "-> {}" do
        let(:compact) { -> {} }
        test_empty self, :enum, line: __LINE__
      end
    end

    describe "select:" do
      let(:enum) { Target.new select: select }

      describe "true" do
        let(:select) { true }
        test_error self, :enum, line: __LINE__
      end

      describe "false" do
        let(:select) { false }
        test_empty self, :enum, line: __LINE__
      end

      describe "nil" do
        let(:select) { nil }
        test_empty self, :enum, line: __LINE__
      end

      describe "Proc.new {}" do
        let(:select) { Proc.new {} }
        test_empty self, :enum, line: __LINE__
      end

      describe "-> {}" do
        let(:select) { -> {} }
        test_empty self, :enum, line: __LINE__
      end
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary }

    describe "0...100" do
      let(:ary) { 0...100 }
      test_all self, :enum, 0...100, line: __LINE__
    end

    describe "Proc.new { 0...100 }" do
      let(:ary) {
        ary = Proc.new { 0...100 }
        allow(ary).to receive(:call).once.and_return 0...100
        ary
      }
      test_all self, :enum, 0...100, line: __LINE__
    end

    describe "Proc.new { |e| 0...100 }" do
      let(:ary) {
        ary = Proc.new { |e| 0...100 }
        allow(ary).to receive(:call).once.and_return 0...100
        ary
      }
      test_all self, :enum, 0...100, line: __LINE__
    end

    describe "Proc.new { |e, i| 0...100 }" do
      let(:ary) {
        ary = Proc.new { |e, i| 0...100 }
        allow(ary).to receive(:call).once.and_return 0...100
        ary
      }
      test_all self, :enum, 0...100, line: __LINE__
    end

    describe "Proc.new { |e, i, x, y, z| 0...100 }" do
      let(:ary) {
        ary = Proc.new { |e, i, x, y, z| 0...100 }
        allow(ary).to receive(:call).once.and_return 0...100
        ary
      }
      test_all self, :enum, 0...100, line: __LINE__
    end

    describe "-> { 0...100 }" do
      let(:ary) {
        ary = -> { 0...100 }
        allow(ary).to receive(:call).once.and_return 0...100
        ary
      }
      test_all self, :enum, 0...100, line: __LINE__
    end

    describe "-> { |e| 0...100 }" do
      let(:ary) {
        ary = -> (c) { 0...100 }
        allow(ary).to receive(:call).once.and_return 0...100
        ary
      }
      test_all self, :enum, 0...100, line: __LINE__
    end

    describe "-> (e, i) { 0...100 }" do
      let(:ary) {
        ary = -> (e, i) { 0...100 }
        allow(ary).to receive(:call).once.and_return 0...100
        ary
      }
      test_all self, :enum, 0...100, line: __LINE__
    end

    describe "-> (e, i, x, y, z) { 0...100 }" do
      let(:ary) {
        ary = -> (e, i, x, y, z) { 0...100 }
        allow(ary).to receive(:call).once.and_return 0...100
        ary
      }
      test_all self, :enum, 0...100, line: __LINE__
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary, first: first }

    describe "0...100," do
      let(:ary) { 0...100 }

      describe "first:" do
        describe "50" do
          let(:first) { 50 }
          test_all self, :enum, 0...50, line: __LINE__
        end

        describe "200" do
          let(:first) { 200 }
          test_all self, :enum, 0...100, line: __LINE__
        end

        describe "'hoge'" do
          let(:first) { "hoge" }
          test_all self, :enum, 0...0, line: __LINE__
        end

        describe "'10hoge'" do
          let(:first) { "10hoge" }
          test_all self, :enum, 0...10, line: __LINE__
        end
      end
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary, compact: compact }

    describe "(0...100).map { |e| e.odd? ? e : nil }," do
      let(:ary) { (0...100).map { |e| e.odd? ? e : nil } }

      describe "compact:" do
        describe "true" do
          let(:compact) { true }
          test_all self, :enum, (1...100).step(2), line: __LINE__
        end

        describe "false" do
          let(:compact) { false }
          test_all self, :enum, (0...100).map { |e| e.odd? ? e : nil }, line: __LINE__
        end

        describe "nil" do
          let(:compact) { nil }
          test_all self, :enum, (0...100).map { |e| e.odd? ? e : nil }, line: __LINE__
        end

        describe "Proc.new { true }" do
          let(:compact) { Proc.new { true } }
          test_all self, :enum, [], line: __LINE__
        end

        describe "Proc.new { false }" do
          let(:compact) { Proc.new { false } }
          test_all self, :enum, (0...100).map { |e| e.odd? ? e : nil }, line: __LINE__
        end

        describe "Proc.new { |e| e.nil? }" do
          let(:compact) { Proc.new { |e| e.nil? } }
          test_all self, :enum, (1...100).step(2), line: __LINE__
        end

        describe "Proc.new { |e| e.nil? or e < 30 }" do
          let(:compact) { Proc.new { |e| e.nil? or e < 30 } }
          test_all self, :enum, (31...100).step(2), line: __LINE__
        end

        describe "Proc.new { |e, i| e.nil? or e < 30 }" do
          let(:compact) { Proc.new { |e, i| e.nil? or e < 30 } }
          test_all self, :enum, (31...100).step(2), line: __LINE__
        end

        describe "Proc.new { |e, i, x, y, z| e.nil? or e < 30 }" do
          let(:compact) { Proc.new { |e, i, x, y, z| e.nil? or e < 30 } }
          test_all self, :enum, (31...100).step(2), line: __LINE__
        end

        describe "-> { true }" do
          let(:compact) { -> { true } }
          test_all self, :enum, [], line: __LINE__
        end

        describe "-> { false }" do
          let(:compact) { -> { false } }
          test_all self, :enum, (0...100).map { |e| e.odd? ? e : nil }, line: __LINE__
        end

        describe "-> (e) { e.nil? }" do
          let(:compact) { -> (e) { e.nil? } }
          test_all self, :enum, (1...100).step(2), line: __LINE__
        end

        describe "-> (e) { e.nil? or e < 30 }" do
          let(:compact) { -> (e) { e.nil? or e < 30 } }
          test_all self, :enum, (31...100).step(2), line: __LINE__
        end

        describe "-> (e, i) { e.nil? or e < 30 }" do
          let(:compact) { -> (e, i) { e.nil? or e < 30 } }
          test_all self, :enum, (31...100).step(2), line: __LINE__
        end

        describe "-> (e, i, x, y, z) { e.nil? or e < 30 }" do
          let(:compact) { -> (e, i, x, y, z) { e.nil? or e < 30 } }
          test_all self, :enum, (31...100).step(2), line: __LINE__
        end
      end
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary, compact: compact, first: first }
    describe "(0...100).map { |e| e.odd? ? e : nil }," do
      let(:ary) { (0...100).map { |e| e.odd? ? e : nil } }
      describe "compact:" do
        describe "-> (e) { e.nil? }," do
          let(:compact) { -> (e) { e.nil? } }

          describe "first:" do
            describe "30" do
              let(:first) { 30 }
              test_all self, :enum, (1...60).step(2), line: __LINE__
            end

            describe "60" do
              let(:first) { 60 }
              test_all self, :enum, (1...100).step(2), line: __LINE__
            end
          end
        end
      end
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary, select: select }

    describe "(0...100).map { |e| e.odd? ? e : nil }," do
      let(:ary) { (0...100).map { |e| e.odd? ? e : nil } }

      describe "select:" do
        describe "nil" do
          let(:select) { nil }
          test_all self, :enum, (0...100).map { |e| e.odd? ? e : nil }, line: __LINE__
        end

        describe "Proc.new { true }" do
          let(:select) { Proc.new { true } }
          test_all self, :enum, (0...100).map { |e| e.odd? ? e : nil }, line: __LINE__
        end

        describe "Proc.new { false }" do
          let(:select) { Proc.new { false } }
          test_all self, :enum, [], line: __LINE__
        end

        describe "Proc.new { |e| e.nil? }" do
          let(:select) { Proc.new { |e| e.nil? } }
          test_all self, :enum, Array.new(50, nil), line: __LINE__
        end

        describe "Proc.new { |e| not e.nil? and e < 30 }" do
          let(:select) { Proc.new { |e| not e.nil? and e < 30 } }
          test_all self, :enum, (1...30).step(2), line: __LINE__
        end

        describe "Proc.new { |e, i| not e.nil? and e < 30 }" do
          let(:select) { Proc.new { |e, i| not e.nil? and e < 30 } }
          test_all self, :enum, (1...30).step(2), line: __LINE__
        end

        describe "Proc.new { |e, i, x, y, z| not e.nil? and e < 30 }" do
          let(:select) { Proc.new { |e, i, x, y, z| not e.nil? and e < 30 } }
          test_all self, :enum, (1...30).step(2), line: __LINE__
        end

        describe "-> { true }" do
          let(:select) { -> { true } }
          test_all self, :enum, (0...100).map { |e| e.odd? ? e : nil }, line: __LINE__
        end

        describe "-> { false }" do
          let(:select) { -> { false } }
          test_all self, :enum, [], line: __LINE__
        end

        describe "-> (e) { e.nil? }" do
          let(:select) { -> (e) { e.nil? } }
          test_all self, :enum, Array.new(50, nil), line: __LINE__
        end

        describe "-> (e) { not e.nil? and e < 30 }" do
          let(:select) { -> (e) { not e.nil? and e < 30 } }
          test_all self, :enum, (1...30).step(2), line: __LINE__
        end

        describe "-> (e, i) { not e.nil? and e < 30 }" do
          let(:select) { -> (e, i) { not e.nil? and e < 30 } }
          test_all self, :enum, (1...30).step(2), line: __LINE__
        end

        describe "-> (e, i, x, y, z) { not e.nil? and e < 30 }" do
          let(:select) { -> (e, i, x, y, z) { not e.nil? and e < 30 } }
          test_all self, :enum, (1...30).step(2), line: __LINE__
        end
      end
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary, select: select, first: first }
    describe "(0...100).map { |e| e.odd? ? e : nil }," do
      let(:ary) { (0...100).map { |e| e.odd? ? e : nil } }
      describe "select:" do
        describe "-> (e) { e.nil? }," do
          let(:select) { -> (e) { e.nil? } }

          describe "first:" do
            describe "30" do
              let(:first) { 30 }
              test_all self, :enum, Array.new(30, nil), line: __LINE__
            end

            describe "60" do
              let(:first) { 60 }
              test_all self, :enum, Array.new(50, nil), line: __LINE__
            end
          end
        end
      end
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary, compact: compact, select: select }
    describe "(0...100).map { |e| e.odd? ? e : nil }," do
      let(:ary) { (0...100).map { |e| e.odd? ? e : nil } }
      describe "compact:" do
        describe "true," do
          let(:compact) { true }

          describe "select:" do
            describe "Proc.new { |e| e.to_i < 30 }" do
              let(:select) { Proc.new{ |e| e.to_i < 30 } }
              test_all self, :enum, (1...30).step(2), line: __LINE__
            end
          end
        end
      end
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary, fill: fill }
    describe "0...100," do
      let(:ary) { 0...100 }

      describe "fill:" do
        describe "nil" do
          let(:fill) { nil }

          test_all self, :enum, 0...100, line: __LINE__
        end

        describe "true" do
          let(:fill) { true }

          test_all self, :enum, 0...100, line: __LINE__
        end

        describe "false" do
          let(:fill) { false }

          test_all self, :enum, 0...100, line: __LINE__
        end
      end
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary, first: first, fill: fill }
    describe "0...100," do
      let(:ary) { 0...100 }
      describe "first:" do
        describe "150," do
          let(:first) { 150 }

          [nil, "hoge", "foo", "bar"].each do |val|
            describe "fill: #{val.inspect}" do
              let(:fill) { val }
              test_interrupt self, :enum, (0...100).to_a, line: __LINE__
            end
          end

          describe "fill:" do
            describe "200...300" do
              let(:fill) { 200...300 }

              test_all self, :enum, (0...100).to_a + (200...250).to_a, line: __LINE__
            end

            describe "Proc.new { 200...300 }" do
              let(:fill) { Proc.new { 200...300 } }

              test_all self, :enum, (0...100).to_a + (200...250).to_a, line: __LINE__
            end

            describe "Proc.new { |c| 200...300 }" do
              let(:fill) {
                _proc = Proc.new { |c| 200...300 }
                expect(_proc).to receive(:call).with(50).once.and_return 200...300
                _proc
              }

              test_equal self, :enum, (0...100).to_a + (200...250).to_a, line: __LINE__
            end

            describe "-> { 200...300 }" do
              let(:fill) { -> { 200...300 } }

              test_all self, :enum, (0...100).to_a + (200...250).to_a, line: __LINE__
            end

            describe "-> (c) { 200...300 }" do
              let(:fill) {
                _proc = -> (c) { 200...300 }
                expect(_proc).to receive(:call).with(50).once.and_return 200...300
                _proc
              }

              test_equal self, :enum, (0...100).to_a + (200...250).to_a, line: __LINE__
            end
          end
        end
      end
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary1, ary2 }
    describe "0...100, 200...250" do
      let(:ary1) { 0...100 }
      let(:ary2) { 200...250 }
      test_all self, :enum, (0...100).to_a + (200...250).to_a, line: __LINE__
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary1, ary2, first: first }
    describe "0...100, 200...250," do
      let(:ary1) { 0...100 }
      let(:ary2) { 200...250 }

      describe "first:" do
        describe "50" do
          let(:first) { 50 }
          test_all self, :enum, 0...50, line: __LINE__
        end

        describe "130" do
          let(:first) { 130 }
          test_all self, :enum, (0...100).to_a + (200...230).to_a, line: __LINE__
        end

        describe "200" do
          let(:first) { 200 }
          test_all self, :enum, (0...100).to_a + (200...250).to_a, line: __LINE__
        end
      end
    end

    describe "Proc.new { 0...100 }, Proc.new { 200...250 }," do
      let(:ary1) { Proc.new { 0...100 } }
      let(:ary2) { Proc.new { 200...250 } }

      describe "first:" do
        describe "50" do
          let(:first) { 50 }
          test_all self, :enum, 0...50, line: __LINE__
        end

        describe "130" do
          let(:first) { 130 }
          test_all self, :enum, (0...100).to_a + (200...230).to_a, line: __LINE__
        end

        describe "200" do
          let(:first) { 200 }
          test_all self, :enum, (0...100).to_a + (200...250).to_a, line: __LINE__
        end
      end
    end

    describe "Proc.new { |c| 0...100 }, Proc.new { |c| 200...250 }," do
      describe "first:" do
        describe "50" do
          let(:ary1) {
            ary = Proc.new { |c| 0...100 }
            allow(ary).to receive(:call).once.with(50).and_return(0...100)
            ary
          }
          let(:ary2) {
            ary = Proc.new { |c| 200...250 }
            allow(ary).to receive(:call).never
            ary
          }
          let(:first) { 50 }
          test_all self, :enum, 0...50, line: __LINE__
        end

        describe "130" do
          let(:ary1) {
            ary = Proc.new { |c| 0...100 }
            allow(ary).to receive(:call).once.with(130).and_return 0...100
            ary
          }
          let(:first) { 130 }

          context "<all>" do
            let(:ary2) {
              ary = Proc.new { |c| 200...250 }
              allow(ary).to receive(:call).once.with(30).and_return 200...250
              ary
            }
            test_equal self, :enum, (0...100).to_a + (200...230).to_a, line: __LINE__
          end

          context "<interrupt>" do
            let(:ary2) {
              ary = Proc.new { |c| 200...250 }
              allow(ary).to receive(:call).never
              ary
            }
            test_interrupt self, :enum, (0...100).to_a + (200...230).to_a, line: __LINE__
          end
        end

        describe "200" do
          let(:ary1) {
            ary = Proc.new { |c| 0...100 }
            allow(ary).to receive(:call).once.with(200).and_return 0...100
            ary
          }
          let(:ary2) { Proc.new { |c| 200...250 } }
          let(:first) { 200 }
          test_all self, :enum, (0...100).to_a + (200...250).to_a, line: __LINE__
        end
      end
    end

    describe "-> { 0...100 }, -> { 200...250 }," do
      let(:ary1) { -> { 0...100 } }
      let(:ary2) { -> { 200...250 } }

      describe "first:" do
        describe "50" do
          let(:first) { 50 }
          test_all self, :enum, 0...50, line: __LINE__
        end

        describe "130" do
          let(:first) { 130 }
          test_all self, :enum, (0...100).to_a + (200...230).to_a, line: __LINE__
        end

        describe "200" do
          let(:first) { 200 }
          test_all self, :enum, (0...100).to_a + (200...250).to_a, line: __LINE__
        end
      end
    end

    describe "-> (c) { 0...100 }, -> (c) { 200...250 }," do
      describe "first:" do
        describe "50" do
          let(:ary1) {
            ary = -> (c) { 0...100 }
            allow(ary).to receive(:call).once.with(50).and_return 0...100
            ary
          }
          let(:ary2) {
            ary = -> (c) { 200...250 }
            allow(ary).to receive(:call).never
            ary
          }
          let(:first) { 50 }
          test_all self, :enum, 0...50, line: __LINE__
        end

        describe "130" do
          let(:ary1) {
            ary = -> (c) { 0...100 }
            allow(ary).to receive(:call).once.with(130).and_return 0...100
            ary
          }
          let(:first) { 130 }

          context "<all>" do
            let(:ary2) {
              ary = -> (c) { 200...250 }
              allow(ary).to receive(:call).once.with(30).and_return 200...250
              ary
            }
            test_equal self, :enum, (0...100).to_a + (200...230).to_a, line: __LINE__
          end

          context "<interrupt>" do
            let(:ary2) {
              ary = -> (c) { 200...250 }
              allow(ary).to receive(:call).never
              ary
            }
            test_interrupt self, :enum, (0...100).to_a + (200...230).to_a, line: __LINE__
          end
        end

        describe "200" do
          let(:ary1) {
            ary = -> (c) { 0...100 }
            allow(ary).to receive(:call).once.with(200).and_return 0...100
            ary
          }
          let(:ary2) { -> (c) { 200...250 } }
          let(:first) { 200 }
          test_all self, :enum, (0...100).to_a + (200...250).to_a, line: __LINE__
        end
      end
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary1, ary2, ary3 }
    describe "0...100, 200...250, 300...330" do
      let(:ary1) { 0...100 }
      let(:ary2) { 200...250 }
      let(:ary3) { 300...330 }
      test_all self, :enum, (0...100).to_a + (200...250).to_a + (300...330).to_a, line: __LINE__
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary1, ary2, ary3, first: first }
    describe "0...100, 200...250, 300...330," do
      let(:ary1) { 0...100 }
      let(:ary2) { 200...250 }
      let(:ary3) { 300...330 }

      describe "first:" do
        describe "50" do
          let(:first) { 50 }
          test_all self, :enum, 0...50, line: __LINE__
        end

        describe "130" do
          let(:first) { 130 }
          test_all self, :enum, (0...100).to_a + (200...230).to_a, line: __LINE__
        end

        describe "170" do
          let(:first) { 170 }
          test_all self, :enum, (0...100).to_a + (200...250).to_a + (300...320).to_a, line: __LINE__
        end

        describe "200" do
          let(:first) { 200 }
          test_all self, :enum, (0...100).to_a + (200...250).to_a + (300...330).to_a, line: __LINE__
        end
      end
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary1, ary2, ary3, first: first }
    describe "Proc.new { |c| 0...100 }, Proc.new { |c| 200...250 }, Proc.new { |c| 300...330 }," do
      describe "first:" do
        describe "50" do
          let(:ary1) {
            ary = Proc.new { |c| 0...100 }
            allow(ary).to receive(:call).once.with(50).and_return 0...100
            ary
          }
          let(:ary2) {
            ary = Proc.new { |c| 200...250 }
            allow(ary).to receive(:call).never
            ary
          }
          let(:ary3) {
            ary = Proc.new { |c| 300...330 }
            allow(ary).to receive(:call).never
            ary
          }
          let(:first) { 50 }
          test_all self, :enum, 0...50, line: __LINE__
        end

        describe "130" do
          let(:ary1) {
            ary = Proc.new { |c| 0...100 }
            allow(ary).to receive(:call).once.with(130).and_return 0...100
            ary
          }
          let(:first) { 130 }

          context "<all>" do
            let(:ary2) {
              ary = Proc.new { |c| 200...250 }
              allow(ary).to receive(:call).once.with(30).and_return 200...250
              ary
            }
            let(:ary3) {
              ary = Proc.new { |c| 300...330 }
              allow(ary).to receive(:call).never
              ary
            }
            test_equal self, :enum, (0...100).to_a + (200...230).to_a, line: __LINE__
          end

          context "<interrupt>" do
            let(:ary2) {
              ary = Proc.new { |c| 200...250 }
              allow(ary).to receive(:call).never
              ary
            }
            let(:ary3) {
              ary = Proc.new { |c| 300...330 }
              allow(ary).to receive(:call).never
              ary
            }
            test_interrupt self, :enum, (0...100).to_a + (200...230).to_a, line: __LINE__
          end
        end

        describe "200" do
          let(:ary1) {
            ary = Proc.new { |c| 0...100 }
            allow(ary).to receive(:call).once.with(200).and_return 0...100
            ary
          }
          let(:first) { 200 }

          context "<all>" do
            let(:ary2) {
              ary = Proc.new { |c| 200...250 }
              allow(ary).to receive(:call).once.with(100).and_return 200...250
              ary
            }
            let(:ary3) {
              ary = Proc.new { |c| 300...330 }
              allow(ary).to receive(:call).once.with(50).and_return 300...330
              ary
            }
            test_equal self, :enum, (0...100).to_a + (200...250).to_a + (300...330).to_a, line: __LINE__
          end

          context "<interrupt>" do
            let(:ary2) {
              ary = Proc.new { |c| 200...250 }
              allow(ary).to receive(:call).never
              ary
            }
            let(:ary3) {
              ary = Proc.new { |c| 300...330 }
              allow(ary).to receive(:call).never
              ary
            }
            test_interrupt self, :enum, (0...100).to_a + (200...250).to_a + (300...330).to_a, line: __LINE__
          end
        end
      end
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary1, ary2, ary3, first: first }
    describe "0...100, Proc.new { 200...250 }, -> (c) { 300...330 }," do
      describe "first:" do
        describe "50" do
          let(:ary1) { 0...100 }
          let(:ary2) {
            ary = Proc.new { |c| 200...250 }
            allow(ary).to receive(:call).never
            ary
          }
          let(:ary3) {
            ary = -> (c) { 300...330 }
            allow(ary).to receive(:call).never
            ary
          }
          let (:first) { 50 }
          test_all self, :enum, 0...50, line: __LINE__
        end

        describe "130" do
          let(:ary1) { 0...100 }
          let (:first) { 130 }

          context "<all>" do
            let(:ary2) {
              ary = Proc.new { |c| 200...250 }
              allow(ary).to receive(:call).once.with(30).and_return 200...250
              ary
            }
            let(:ary3) {
              ary = -> (c) { 300...330 }
              allow(ary).to receive(:call).never
              ary
            }
            test_equal self, :enum, (0...100).to_a + (200...230).to_a, line: __LINE__
          end

          context "<interrupt>" do
            let(:ary2) {
              ary = Proc.new { |c| 200...250 }
              allow(ary).to receive(:call).never
              ary
            }
            let(:ary3) {
              ary = -> (c) { 300...330 }
              allow(ary).to receive(:call).never
              ary
            }
            test_interrupt self, :enum, (0...100).to_a + (200...230).to_a, line: __LINE__
          end
        end

        describe "200" do
          let(:ary1) { 0...100 }
          let (:first) { 200 }

          context "<all>" do
            let(:ary2) {
              ary = Proc.new { |c| 200...250 }
              allow(ary).to receive(:call).once.with(100).and_return 200...250
              ary
            }
            let(:ary3) {
              ary = -> (c) { 300...330 }
              allow(ary).to receive(:call).once.with(50).and_return 300...330
              ary
            }
            test_equal self, :enum, (0...100).to_a + (200...250).to_a + (300...330).to_a, line: __LINE__
          end

          context "<interrupt>" do
            let(:ary2) {
              ary = Proc.new { |c| 200...250 }
              allow(ary).to receive(:call).never
              ary
            }
            let(:ary3) {
              ary = -> (c) { 300...330 }
              allow(ary).to receive(:call).never
              ary
            }
            test_interrupt self, :enum, (0...100).to_a + (200...250).to_a + (300...330).to_a, line: __LINE__
          end
        end
      end
    end
  end

  describe ".new" do
    describe "0...100, Proc.new { 200...250 }, -> (c) { 300...330 }, first: 200" do
      let(:enum) { Target.new 0...100, Proc.new { 200...250 }, -> (c) { 300...330 }, first: 200 }
      context "<is_a?>" do
        it { expect(enum).to be_a Enumerable }
      end
      context "#each <is_a?>" do
        subject { enum.each }
        it { is_expected.to be_a Enumerable }
        it { is_expected.not_to be_a Array }
        it { is_expected.not_to be enum }
      end
      context "#each#to_a <is_a?>" do
        subject { enum.each.to_a }
        it { is_expected.to be_a Array }
        it { is_expected.to eq enum.to_a }
      end
    end
  end

  describe ".new" do
    let(:enum) { Target.new ary1, ary2, ary3, first: 200 }
    describe "0...100, Proc.new { 200...250 }, -> { 300...330 }, first: 200" do
      let(:ary1) {
        ary = 0...100
        allow(ary).to receive(:first).with(200) { |c| (0...100).first c }
        ary
      }
      let(:ary2) {
        ary = 200...250
        _proc = Proc.new { ary }
        allow(_proc).to receive(:call).with(no_args).and_return ary
        allow(ary).to receive(:first).with(100) { |c| (200...250).first c }
        _proc
      }
      let(:ary3) {
        ary = 300...330
        _proc = -> { ary }
        allow(_proc).to receive(:call).with(no_args).and_return ary
        allow(ary).to receive(:first).with(50) { |c| (300...330).first c }
        _proc
      }

      context "<whitebox>" do
        test_equal self, :enum, (0...100).to_a + (200...250).to_a + (300...330).to_a, line: __LINE__
      end
    end

    describe "0...100, Proc.new { |c| 200...250 }, -> (c) { 300...330 }, first: 200" do
      let(:ary1) {
        ary = 0...100
        allow(ary).to receive(:first).with(200).and_return 0...100
        ary
      }
      let(:ary2) {
        ary = 200...250
        _proc = Proc.new { |c| ary }
        allow(_proc).to receive(:call).with(100).and_return ary
        allow(ary).to receive(:first).never
        _proc
      }
      let(:ary3) {
        ary = 300...330
        _proc = -> (c) { ary }
        allow(_proc).to receive(:call).with(50).and_return ary
        allow(ary).to receive(:first).never
        _proc
      }

      context "<whitebox>" do
        test_equal self, :enum, (0...100).to_a + (200...250).to_a + (300...330).to_a, line: __LINE__
      end
    end
  end

  describe ".new" do
    describe "0...100, Array.new(10, nil), Proc.new { |c| 200...250 }, first: 130, compact: true, map: -> (e) { e * 2 }" do
      let(:enum) { Target.new 0...100, Array.new(10, nil), Proc.new { |c| 200...250 }, first: 130, compact: true, map: map }

      describe "map: nil" do
        let(:map) { nil }
        subject { enum.to_a }
        it { is_expected.to eq (0...100).to_a + (200...230).to_a }
      end

      describe "map: false" do
        let(:map) { false }
        subject { enum.to_a }
        it { is_expected.to eq (0...100).to_a + (200...230).to_a }
      end

      describe "map: true" do
        let(:map) { true }
        subject { enum.to_a }
        it { expect { is_expected }.to raise_error }
      end

      ["hoge", "foo", "bar"].each do |m|
        describe "map: #{m.inspect}" do
          let(:map) { m }
          subject { enum.to_a }
          it { expect { is_expected }.to raise_error }
        end
      end

      describe "map: -> { 100 }" do
        let(:map) {
          _proc = -> { raise "using stub" }
          expect(_proc).to receive(:call).with(no_args).exactly(130).times.and_return 100
          _proc
        }
        subject { enum.to_a }
        it { is_expected.to eq Array.new(130, 100) }
      end

      describe "map: -> (e) { e * 2 }" do
        let(:map) {
          _proc = -> (e) { raise "using stub" }
          expect(_proc).to receive(:call).exactly(130).times do |e|
            e * 2
          end
          _proc
        }
        subject { enum.to_a }
        it { is_expected.to eq ((0...100).to_a + (200...230).to_a).map{ |e| e * 2 } }
      end

      describe "map: -> (e, i) { i }" do
        let(:map) {
          _proc = -> (e, i) { raise "using stub" }
          expect(_proc).to receive(:call).exactly(130).times do |e, i|
            i
          end
          _proc
        }
        subject { enum.to_a }
        it { is_expected.to eq (0...130).to_a }
      end

      describe "map: -> (e, i, x, y, z) { i }" do
        let(:map) {
          _proc = -> (e, i, x, y, z) { raise "using stub" }
          expect(_proc).to receive(:call).exactly(130).times do |e, i|
            i
          end
          _proc
        }
        subject { enum.to_a }
        it { is_expected.to eq (0...130).to_a }
      end
    end
  end

  describe ".new" do
    describe "-> { 0...100 }," do
      let(:enum) { Target.new ary, cache: cache }

      describe "cache: false" do
        let(:cache) { false }
        let(:ary) {
          _proc = -> (e) { raise "using stub" }
          expect(_proc).to receive(:call).exactly(10).times.and_return 0...100
          _proc
        }
        it { 10.times { enum.to_a } }
      end

      describe "cache: true" do
        let(:cache) { true }
        let(:ary) {
          _proc = -> (e) { raise "using stub" }
          expect(_proc).to receive(:call).exactly(2).times.and_return 0...100
          _proc
        }
        it {
          10.times { enum.to_a }
          enum.options! cache: false
          enum.to_a
        }
      end
    end
  end

  describe ".new" do
    describe "0...100, Proc.new { |c| 200...250 }, first: 160" do
      let(:enum) { Target.new 0...100, Proc.new { |c| 200...250 }, first: 160 }
      it { expect(enum).to be enum }

      describe "#concat -> (c) { 300...330 }" do
        it { expect(enum.concat []).not_to be enum }
        it { expect(enum.concat([]).to_a).to eq enum.to_a }

        let(:ary) { -> (c) { 300...330 } }

        subject { enum.concat(ary).to_a }
        it { is_expected.to eq (0...100).to_a + (200...250).to_a + (300...310).to_a }
      end

      describe "#concat! -> (c) { 300...330 }" do
        it { expect(enum.concat! [1, 2, 3]).to eq enum }

        let(:ary) { -> (c) { 300...330 } }

        subject { enum.concat!(ary).to_a }
        it { is_expected.to eq (0...100).to_a + (200...250).to_a + (300...310).to_a }
      end
    end
  end

  describe ".new" do

    def options enum
      enum.instance_eval { @options }
    end

    describe "0...100, 200...250, 300...330" do
      let(:enum) { Target.new 0...100, 200...250, 300...330 }
      let(:ary) { (0...100).to_a + (200...250).to_a + (300...330).to_a }

      context "<eq>" do
        subject { enum.to_a }
        it { is_expected.not_to be ary }
        it { is_expected.to eq ary }
      end

      [true, 1, "hoge"].each do |opt|
        context "#merge_optons #{opt.inspect}" do
          subject { enum.merge_options(opt).to_a }
          it { expect { is_expected }.to raise_error }
        end
      end

      [true, 1, "hoge"].each do |opt|
        context "#merge_optons! #{opt.inspect}" do
          subject { enum.merge_options!(opt).to_a }
          it { expect { is_expected }.to raise_error }
        end
      end

      [true, 1, "hoge"].each do |opt|
        context "#replace_optons #{opt.inspect}" do
          subject { enum.replace_options(opt).to_a }
          it { expect { is_expected }.to raise_error }
        end
      end

      [true, 1, "hoge"].each do |opt|
        context "#replace_optons! #{opt.inspect}" do
          subject { enum.replace_options!(opt).to_a }
          it { expect { is_expected }.to raise_error }
        end
      end

      [nil, false, {}].each do |opt|
        context "#merge_optons #{opt.inspect}" do
          subject { enum.merge_options(opt).to_a }
          it { is_expected.to eq ary }
        end
      end

      [nil, false, {}].each do |opt|
        context "#merge_optons! #{opt.inspect}" do
          subject { enum.merge_options!(opt).to_a }
          it { is_expected.to eq ary }
        end
      end

      [nil, false, {}].each do |opt|
        context "#replace_optons #{opt.inspect}" do
          subject { enum.replace_options(opt).to_a }
          it { is_expected.to eq ary }
        end
      end

      [nil, false, {}].each do |opt|
        context "#replace_optons! #{opt.inspect}" do
          subject { enum.replace_options!(opt).to_a }
          it { is_expected.to eq ary }
        end
      end

      context "#merge_optons({ first: 160 })" do
        subject { enum.merge_options({ first: 160 }).to_a }
        it { is_expected.to eq ary[0...160] }
      end

      context "#merge_optons!({ first: 160 })" do
        subject { enum.merge_options!({ first: 160 }).to_a }
        it { is_expected.to eq ary[0...160] }
      end

      context "#replace_optons({ first: 160 })" do
        subject { enum.replace_options({ first: 160 }).to_a }
        it { is_expected.to eq ary[0...160] }
      end

      context "#replace_optons!({ first: 160 })" do
        subject { enum.replace_options!({ first: 160 }).to_a }
        it { is_expected.to eq ary[0...160] }
      end
    end

    describe "0...100, 200...250, 300...330, { first: 80 }" do
      let(:enum) { Target.new 0...100, 200...250, 300...330, { first: 80 } }
      let(:ary) { (0...100).to_a + (200...250).to_a + (300...330).to_a }

      context "<eq>" do
        subject { enum.to_a }
        it { is_expected.to eq ary[0...80] }
      end

      [nil, false, {}].each do |opt|
        context "#merge_optons #{opt.inspect}" do
          subject { enum.merge_options(opt).to_a }
          it { is_expected.to eq ary[0...80] }
        end
      end

      [nil, false, {}].each do |opt|
        context "#merge_optons! #{opt.inspect}" do
          subject { enum.merge_options!(opt).to_a }
          it { is_expected.to eq ary[0...80] }
        end
      end

      [nil, false, {}].each do |opt|
        context "#replace_optons #{opt.inspect}" do
          subject { enum.replace_options(opt).to_a }
          it { is_expected.to eq ary }
        end
      end

      [nil, false, {}].each do |opt|
        context "#replace_optons! #{opt.inspect}" do
          subject { enum.replace_options!(opt).to_a }
          it { is_expected.to eq ary }
        end
      end

      context "#merge_optons({ first: 160 })" do
        subject { enum.merge_options({ first: 160 }).to_a }
        it { is_expected.to eq ary[0...160] }
      end

      context "#merge_optons!({ first: 160 })" do
        subject { enum.merge_options!({ first: 160 }).to_a }
        it { is_expected.to eq ary[0...160] }
      end

      context "#replace_optons({ first: 160 })" do
        subject { enum.replace_options({ first: 160 }).to_a }
        it { is_expected.to eq ary[0...160] }
      end

      context "#replace_optons!({ first: 160 })" do
        subject { enum.replace_options!({ first: 160 }).to_a }
        it { is_expected.to eq ary[0...160] }
      end
    end

    context "<whitebox>" do
      [
        {}, { first: 100 }, { compact: true },
        { hoge: "hoge", foo: "foo" }
      ].each do |opts|
        describe "0...100, #{opts.inspect}" do
          let(:enum) { Target.new 0...100, opts }

          context "<@options>" do
            subject { options enum }
            it { is_expected.to eq opts }
          end

          [
            nil, {},
            { first: 100 }, { compact: true },
            { hoge: "hoge", foo: "foo" }
          ].each do |opts_2|
            describe "#merge_options(#{opts_2.inspect})" do
              let(:enum_2) { enum.merge_options opts_2 }

              context "<eq>" do
                subject { enum_2 }
                it { is_expected.not_to be enum }
              end

              context "<@options>" do
                subject { options enum_2 }
                it { is_expected.not_to be opts }
                it { is_expected.not_to be opts_2 }
                it { is_expected.to eq (opts || {}).merge opts_2 || {} }
              end
            end

            describe "#merge_options!(#{opts_2.inspect})" do
              let(:enum_2) { enum.merge_options! opts_2 }

              context "<eq>" do
                subject { enum_2 }
                it { is_expected.to be enum }
              end

              context "<@options>" do
                subject { options enum_2 }
                it { is_expected.to be opts }
                it { is_expected.not_to be opts_2 }
                it { is_expected.to eq (opts || {}).merge opts_2 || {} }
              end
            end

            describe "#replace_options(#{opts_2.inspect})" do
              let(:enum_2) { enum.replace_options opts_2 }

              context "<eq>" do
                subject { enum_2 }
                it { is_expected.not_to be enum }
              end

              context "<@options>" do
                subject { options enum_2 }
                it { is_expected.not_to be opts }
                if opts_2
                  it { is_expected.to be opts_2 }
                else
                  it { is_expected.to eq({}) }
                end
              end
            end

            describe "#replace_options!(#{opts_2.inspect})" do
              let(:enum_2) { enum.replace_options! opts_2 }

              context "<eq>" do
                subject { enum_2 }
                it { is_expected.to be enum }
              end

              context "<@options>" do
                subject { options enum_2 }
                it { is_expected.not_to be opts }
                if opts_2
                  it { is_expected.to be opts_2 }
                else
                  it { is_expected.to eq({}) }
                end
              end
            end
          end
        end
      end

      context "<alias>" do
        [
          [:merge_options, :options], [:merge_options!, :options!]
        ].each do |methods|
          context do
            subject { Target.instance_method methods[0] }
            it { is_expected.to eq Target.instance_method methods[1] }
          end
        end
      end
    end
  end
end

