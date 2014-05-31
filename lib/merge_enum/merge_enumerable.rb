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

      opt_cache = @options[:cache]
      if opt_cache
        if @cache
          @cache.each &block
          return self
        end
      elsif @cache
        @cache = nil
      end

      # options
      opt_fst = @options[:first]
      opt_fst = opt_fst.to_i if opt_fst
      (opt_proc, _proc) = merge_options_proc @options
      (opt_map, _map) = map_proc @options

      # local variables
      cnt = 0
      fst = nil
      cache = [] if opt_cache

      @collections.each do |c|
        if opt_fst
          fst = opt_fst - cnt
          break if fst <= 0
        end

        # get enumerable
        called_first = false
        if c.is_a? Proc
          arity = c.arity.abs
          case arity
          when 0
            c = c.call
          when 1
            c = c.call fst
            called_first = true
          when 2
            c = c.call fst, opt_proc
            called_first = true
          else
            args = Array.new arity - 2, nil
            c = c.call fst, opt_proc, *args
            called_first = true
          end
        end

        if fst
          # with first option
          c = c.first fst unless called_first or _proc
          _cnt = 0
          c.each do |e|
            next if _proc and not opt_proc.call e, cnt
            e = opt_map.call e, cnt if _map
            block.call e
            cache.push e if cache
            cnt += 1
            _cnt += 1
            break if fst <= _cnt
          end
        else
          # without first option
          c.each do |e|
            next if _proc and not opt_proc.call e, cnt
            e = opt_map.call e, cnt if _map
            block.call e
            cache.push e if cache
            cnt += 1
          end
        end
      end

      @cache = cache if cache

      self
    end

    private

    def merge_options_proc options
      opts = []

      opt_cmpct = options[:compact]
      opts << if opt_cmpct.is_a? Proc
                arity = opt_cmpct.arity.abs
                case arity
                when 0
                  [-> (e, i) { not opt_cmpct.call }, true]
                when 1
                  [-> (e, i) { not opt_cmpct.call e }, true]
                when 2
                  [-> (e, i) { not opt_cmpct.call e, i }, true]
                else
                  args = Array.new arity - 2, nil
                  [-> (e, i) { not opt_cmpct.call e, i, *args }, true]
                end
              elsif opt_cmpct
                [-> (e, i) { not e.nil? }, true]
              else
                [-> (e, i) { true }, false]
              end

      opt_slct = options[:select]
      opts << if opt_slct.is_a? Proc
                arity = opt_slct.arity.abs
                case arity
                when 0
                  [-> (e, i) { opt_slct.call }, true]
                when 1
                  [-> (e, i) { opt_slct.call e }, true]
                when 2
                  [-> (e, i) { opt_slct.call e, i }, true]
                else
                  args = Array.new arity - 2, nil
                  [-> (e, i) { opt_slct.call e, i, *args }, true]
                end
              elsif opt_slct
                raise ":select is must be a Proc"
              else
                [-> (e, i) { true }, false]
              end

      [
        -> (e, i) { opts.all?{ |opt| opt[0].call e, i } },
        opts.any?{ |opt| opt[1] }
      ]
    end

    def map_proc options
      opt_map = options[:map]
      if opt_map
        unless opt_map.is_a? Proc
          raise ":map is must be a Proc"
        end
        arity = opt_map.arity.abs
        case arity
        when 0
          [-> (e, i) { opt_map.call }, true]
        when 1
          [-> (e, i) { opt_map.call e }, true]
        when 2
          [opt_map, true]
        else
          args = Array.new arity - 2, nil
          [-> (e, i) { opt_map.call e, i, *args }, true]
        end
      else
        [-> (e, i) { e }, false]
      end
    end

    public

    def concat arg
      self.class.new *@collections, arg, @options
    end

    def concat! arg
      @collections.push arg
      self
    end

    def merge_options opts
      raise "opts must be a Hash" if opts and not opts.is_a? Hash
      self.class.new *@collections, (@options.merge opts || {})
    end

    def merge_options! opts
      raise "opts must be a Hash" if opts and not opts.is_a? Hash
      @options.merge! opts || {}
      self
    end

    def replace_options opts
      raise "opts must be a Hash" if opts and not opts.is_a? Hash
      self.class.new *@collections, opts || {}
    end

    def replace_options! opts
      raise "opts must be a Hash" if opts and not opts.is_a? Hash
      @options = opts || {}
      self
    end

    alias_method :options, :merge_options

    alias_method :options!, :merge_options!

  end

end

