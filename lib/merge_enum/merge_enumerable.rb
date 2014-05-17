# encoding: utf-8
module MergeEnum

  class MergeEnumerable
    include Enumerable

    def initialize *args
      if args.last.is_a? Hash
        @options = args.delete_at -1
        @collections = args
      else
        @options = {}
        @collections = args
      end
    end

    def each &block
      return self.to_enum unless block_given?
      cnt = 0
      opt_fst = @options[:first]
      fst = nil
      @collections.each do |c|
        if opt_fst
          fst = opt_fst - cnt
          break if fst <= 0
        end
        called_first = false
        if c.is_a? Proc
          if c.arity == 0
            c = c.call
          else
            c = c.call fst
            called_first = true
          end
        end
        if fst
          c = c.first fst unless called_first
          _cnt = 0
          c.each.with_index 1 do |e, i|
            block.call e
            _cnt = i
            break if fst <= _cnt
          end
          cnt += _cnt
        else
          c.each do |e|
            block.call e
          end
        end
      end
      self
    end

    def concat arg
      self.class.new *@collections, arg, @options
    end

    def concat! arg
      @collections.push arg
      self
    end

  end

end

