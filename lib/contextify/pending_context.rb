module Contextify
  class PendingContext

    # The path being loaded
    attr_reader :path

    # The blocks to be loaded
    attr_accessor :blocks

    #
    # Creates a new PendingContext object with the specified _path_.
    #
    # @param [String] path
    #   The path the pending context was loaded from.
    #
    def initialize(path)
      @path = File.expand_path(path)
      @blocks = {}
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
      @blocks.each(&block)
    end

  end
end
