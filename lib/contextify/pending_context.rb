module Contextify
  class PendingContext

    # The path being loaded
    attr_reader :path

    # The blocks to be loaded
    attr_accessor :blocks

    #
    # Creates a new PendingContext object with the specified _path_.
    #
    def initialize(path)
      @path = File.expand_path(path)
      @blocks = {}
    end

    #
    # Iterates over each block in the pending context, passing their name
    # and value to the given _block_.
    #
    def each_block(&block)
      @blocks.each(&block)
    end

  end
end
