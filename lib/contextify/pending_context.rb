module Contextify
  class PendingContext

    include Enumerable

    # The path being loaded
    attr_reader :path

    # The blocks to be loaded
    attr_accessor :blocks

    #
    # Creates a new PendingContext object.
    #
    # @param [String] path
    #   The path the pending context was loaded from.
    #
    def initialize(path)
      @path = File.expand_path(path)
      @blocks = {}
    end

    #
    # Iterates over each context name in the pending context.
    #
    # @yield [name]
    #   The block will be passed each name of the pending context blocks.
    #
    # @yieldparam [String] name
    #   The name of a pending context block.
    #
    def each_class(&block)
      @blocks.each_key do |name|
        block.call(Contextify.contexts[name])
      end
    end

    #
    # Iterates over each block in the pending context.
    #
    # @yield [block]
    #   The block will be passed each pending context block.
    #
    # @yieldparam [Proc] block
    #   A pending context block.
    #
    def each_block(&block)
      @blocks.each_value(&block)
    end

    #
    # Iterates over each context name and block in the pending context.
    #
    # @yield [name, block]
    #   The block will be passed each pending context block and it's
    #   context name.
    #
    # @yieldparam [String] name
    #   The context name of the block.
    #
    # @yieldparam [Proc] block
    #   A pending context block.
    #
    def each(&block)
      @blocks.each(&block)
    end

  end
end
