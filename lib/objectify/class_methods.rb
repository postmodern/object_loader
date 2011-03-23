module Objectify
  module ClassMethods
    #
    # Loads a block for the Class.
    #
    # @param [String] path
    #   The path to load the block from.
    #
    # @return [Proc]
    #   The block defined for the Class.
    #
    # @since 1.0.0
    #
    def load_object_block(path)
      Objectify.load_blocks(path)[self]
    end

    #
    # Loads a compatible object.
    #
    # @param [String] path
    #   The path to load the object from.
    #
    # @param [Array] arguments
    #   Additional arguments to use when creating the object.
    #
    # @return [Object]
    #   The loaded object.
    #
    # @since 1.0.0
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

    #
    # Creates a loadable object using the arguments and block.
    #
    # @param [Array] args
    #   Additional arguments to pass to the Classes `new` method.
    #
    # @yield []
    #   The given block will be instance evaled into the newly created
    #   object when the object is loaded.
    #
    # @since 1.0.0
    #
    def objectify(*args,&block)
      if (args.empty? && Objectify.is_pending?)
        Objectify.pending[self] = block
        return nil
      else
        new_object = self.new(*args)
        new_object.instance_eval(&block) if block
        return new_object
      end
    end
  end
end
