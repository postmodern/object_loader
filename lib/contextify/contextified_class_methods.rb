module Contextify
  module ContextifiedClassMethods
    # The name of the context
    attr_reader :context_name

    #
    # Loads a block defined under the context.
    #
    # @param [String] path
    #   The path to load the block from.
    #
    # @return [Proc]
    #   The block defined for the context.
    #
    def load_context_block(path)
      Contextify.load_block(@context_name,path)
    end

    #
    # Loads a compatible context.
    #
    # @param [String] path
    #   The path to load the context from.
    #
    # @param [Array] arguments
    #   Additional arguments to use when creating the context.
    #
    # @return [Object]
    #   The loaded context.
    #
    def load_context(path,*arguments)
      pending = Contextify.load_blocks(path)

      pending_name, pending_block = pending.find do |name,block|
        Contextify.contexts[name].ancestors.include?(self)
      end

      if (pending_name && pending_block)
        obj = Contextify.contexts[pending_name].new(*arguments)
        obj.instance_eval(&pending_block)
        obj
      end
    end
  end
end
