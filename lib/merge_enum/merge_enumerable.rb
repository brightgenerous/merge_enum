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

      # options
      opt_fst = @options[:first]
      opt_fst = opt_fst.to_i if opt_fst
      opt_cmpct = @options[:compact]
      opt_cmpct_proc = if opt_cmpct.is_a? Proc
                         if opt_cmpct.arity == 0
                           -> (e) { opt_cmpct.call }
                         else
                           opt_cmpct
                         end
                       elsif opt_cmpct
                         -> (e) { e.nil? }
                       else
                         -> (e) { false }
                       end

      # local variables
      cnt = 0
      fst = nil

      @collections.each do |c|
        if opt_fst
          fst = opt_fst - cnt
          break if fst <= 0
        end

        # get enumerable
        called_first = false
        if c.is_a? Proc
          case c.arity
          when 0
            c = c.call
          when 1
            c = c.call fst
            called_first = true
          else
            c = c.call fst, opt_cmpct
            called_first = true
          end
        end

        if fst
          # with first option
          c = c.first fst unless called_first or opt_cmpct
          _cnt = 0
          c.each do |e|
            next if opt_cmpct_proc.call e
            block.call e
            _cnt += 1
            break if fst <= _cnt
          end
          cnt += _cnt
        else
          # without first option
          c.each do |e|
            next if opt_cmpct_proc.call e
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

