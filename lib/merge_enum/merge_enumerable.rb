# -*- coding: utf-8 -*-
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
        if c.is_a? Proc
          if c.arity == 0
            c = c.call
          else
            c = c.call fst
          end
        end
        c = c.first fst if fst
        c.each do |i|
          block.call i
        end
        cnt += c.count
      end
      self
    end

  end

end

