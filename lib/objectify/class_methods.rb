module Objectify
  module ClassMethods
    #
    # Loads a block defined under the context.
    #
    # @param [String] path
    #   The path to load the block from.
    #
    # @return [Proc]
    #   The block defined for the context.
    #
    def load_object_block(path)
      Objectify.load_blocks(path)[self]
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
    def load_object(path,*arguments)
      pending = Objectify.load_blocks(path)

      pending_class, pending_block = pending.find do |klass,block|
        klass.ancestors.include?(self)
      end

      if (pending_class && pending_block)
        obj = pending_class.new(*arguments)
        obj.instance_eval(&pending_block)
        obj
      end
    end

    def objectify(*args,&block)
      if (args.empty? && Objectify.is_pending?)
        Objectify.pending[self] = block
        return nil
      else
        new_context = self.new(*args)
        new_context.instance_eval(&block) if block
        return new_context
      end
    end
  end
end
