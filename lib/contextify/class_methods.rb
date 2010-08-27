require 'contextify/contextified_class_methods'

module Contextify
  module ClassMethods
    #
    # Contextifies the class.
    #
    # @param [Symbol, String] name
    #   The context name to assign to the class.
    #
    def contextify(name)
      name = name.to_s

      @context_name = name
      extend ContextifiedClassMethods

      Contextify.contexts[name] = self

      # define the top-level context wrappers
      Kernel.module_eval %{
        def #{name}(*args,&block)
          if (args.empty? && ::Contextify.is_pending?)
            ::Contextify.pending.blocks[#{name.dump}] = block
            return nil
          else
            new_context = #{self}.new(*args)
            new_context.instance_eval(&block) if block
            return new_context
          end
        end
      }
    end
  end
end
