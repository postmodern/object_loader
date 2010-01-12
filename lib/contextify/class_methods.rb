require 'contextify/extensions'

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

      Contextify.contexts[name] = self

      meta_def(:context_name) { name }

      meta_def(:load_context_block) do |path|
        Contextify.load_block(name,path)
      end

      meta_def(:load_context) do |path,*args|
        pending = Contextify.load_blocks(path)

        context, block = pending.find do |name,block|
          Contextify.contexts[name].ancestors.include?(self)
        end

        if (context && block)
          obj = Contextify.contexts[name].new(*args)
          obj.instance_eval(&block)
          obj
        end
      end

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
