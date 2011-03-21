module Objectify
  class PendingObject < Hash

    # The path being loaded
    attr_reader :path

    #
    # Creates a new {PendingObject} object.
    #
    # @param [String] path
    #   The path the pending object was loaded from.
    #
    def initialize(path)
      @path = File.expand_path(path)

      super()
    end

    alias each_class each_key
    alias each_block each_value

  end
end
