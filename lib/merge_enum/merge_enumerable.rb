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
      (opt_proc, _proc) = merge_options_proc @options

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
            c = c.call fst, opt_proc
            called_first = true
          end
        end

        if fst
          # with first option
          c = c.first fst unless called_first or _proc
          _cnt = 0
          c.each do |e|
            next if _proc and not opt_proc.call e
            block.call e
            _cnt += 1
            break if fst <= _cnt
          end
          cnt += _cnt
        else
          # without first option
          c.each do |e|
            next if _proc and not opt_proc.call e
            block.call e
          end
        end
      end
      self
    end

    private

    def merge_options_proc options
      opts = []

      opt_cmpct = options[:compact]
      opts << if opt_cmpct.is_a? Proc
                if opt_cmpct.arity == 0
                  [-> (e) { not opt_cmpct.call }, true]
                else
                  [-> (e) { not opt_cmpct.call e }, true]
                end
              elsif opt_cmpct
                [-> (e) { not e.nil? }, true]
              else
                [-> (e) { true }, false]
              end

      opt_slct = options[:select]
      opts << if opt_slct.is_a? Proc
                if opt_slct.arity == 0
                  [-> (e) { opt_slct.call }, true]
                else
                  [opt_slct, true]
                end
              elsif opt_slct
                raise ":select is must be a Proc"
              else
                [-> (e) { true }, false]
              end

      [
        -> (e) { opts.all?{ |opt| opt[0].call e } },
        opts.any?{ |opt| opt[1] }
      ]
    end

    public

    def concat arg
      self.class.new *@collections, arg, @options
    end

    def concat! arg
      @collections.push arg
      self
    end

  end

end

