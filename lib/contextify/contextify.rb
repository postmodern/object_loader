require 'contextify/exceptions'
require 'contextify/extensions'
require 'contextify/pending_context'

module Contextify
  def self.included(base)
    base.module_eval do
      #
      # Contextifies the class.
      #
      # @param [Symbol, String] name
      #   The context name to assign to the class.
      #
      def self.contextify(name)
        name = name.to_s

        Contextify.contexts[name] = self

        meta_def(:context_name) { name }

        meta_def(:load_context_block) do |path|
          Contextify.load_block(name,path)
        end

        meta_def(:load_context) do |path,*args|
          pending = Contextify.load_blocks(path)
          obj = nil

          context, block = pending.blocks.find do |name,block|
            Contextify.contexts[name].ancestors.include?(self)
          end

          obj = Contextify.contexts[name].new(*args)
          obj.instance_eval(&block)
          obj
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

    #
    # @return [Hash]
    #   All defined contexts.
    #
    def Contextify.contexts
      @@contextify_contexts ||= {}
    end

    #
    # Determines whether a context with a specific name has been defined.
    #
    # @return [Boolean]
    #   Specifies whether there is a context defined with the specified
    #   name.
    #
    def Contextify.is_context?(name)
      Contextify.contexts.has_key?(name.to_s)
    end

    #
    # The contexts waiting to be fully loaded.
    #
    # @return [Array<PendingContext>]
    #   Contexts which are waiting to be loaded.
    #
    def Contextify.waiting
      @@contextify_waiting_contexts ||= []
    end

    #
    # The first context waiting to be fully loaded.
    #
    # @return [PendingContext]
    #   The pending context being loaded.
    #
    def Contextify.pending
      Contextify.waiting.first
    end

    #
    # Determines whether there are pending contexts.
    #
    # @return [Boolean]
    #   Specifies whether there is a pending context present.
    #
    def Contextify.is_pending?
      !(Contextify.waiting.empty?)
    end

    #
    # Finds the first pending context being loaded from a specific path.
    #
    # @return [PendingContext]
    #   The first pending context with the specified path.
    #
    def Contextify.loading(path)
      Contextify.waiting.each do |pending|
        if pending.path == path
          return pending
        end
      end

      return nil
    end

    #
    # Determines whether contexts are being loaded from a specific path.
    #
    # @return [Boolean]
    #   Specifies whether pending contexts are being loaded from the
    #   specified path.
    #
    def Contextify.is_loading?(path)
      !(Contextify.loading(path).nil?)
    end

    #
    # Loads all context blocks from a specific path.
    #
    # @param [String] path
    #   The path to load all context blocks from.
    #
    # @return [PendingContext]
    #   The pending context which contains the blocks.
    #
    def Contextify.load_blocks(path,&block)
      path = File.expand_path(path)

      unless File.file?(path)
        raise(ContextNotFound,"context #{path.dump} doest not exist",caller)
      end

      # prevent circular loading of contexts
      unless Contextify.is_pending?
        # push on the new pending context
        Contextify.waiting.unshift(PendingContext.new(path))

        load(path)
      end

      # pop off and return the pending context
      pending_context = Contextify.waiting.shift

      block.call(pending_context) if block
      return pending_context
    end

    #
    # Loads the context block for the context with the specific name
    # from a specific path.
    #
    # @param [Symbol, String] name
    #   The name of the context to load the block for.
    #
    # @param [String] path
    #   The path to load the context block from.
    #
    # @yield [block]
    #   The block which will receive the context block.
    #
    # @yieldparam [Proc] block
    #   The context block loaded from the specified _path_.
    #
    # @return [Proc]
    #   The block for the context with the specified _name_.
    #
    # @example
    #   Contextify.load_block(:exploit,'/path/to/my_exploit.rb')
    #   # => Proc
    #
    # @example
    #   Contextify.load_block(:shellcode,'/path/to/execve.rb') do |block|
    #     # ...
    #   end
    #
    def Contextify.load_block(name,path,&block)
      context_block = Contextify.load_blocks(path).blocks[name.to_s]

      block.call(context_block) if block
      return context_block
    end

    #
    # Loads the context object of a specific name and from the specific
    # path.
    #
    # @param [Symbol, String] name
    #   The name of the context to load.
    #
    # @param [String] path
    #   The path to load the context object from.
    #
    # @return [Object]
    #   The loaded context object.
    #
    # @raise [UnknownContext]
    #   No context was defined with the specific name.
    #
    # @example
    #   Contextify.load_context(:note,'/path/to/my_notes.rb')
    #   # => Note
    #
    def Contextify.load_context(name,path,*arguments)
      name = name.to_s

      unless Contextify.is_context?(name)
        raise(UnknownContext,"unknown context #{name.dump}",caller)
      end

      new_context = Contextify.contexts[name].new(*arguments)

      Contextify.load_block(name,path) do |context_block|
        new_context.instance_eval(&context_block) if context_block
      end

      return new_context
    end

    #
    # Loads all context objects from a specific path.
    #
    # @param [String] path
    #   The path to load all context objects from.
    #
    # @return [Array]
    #   The array of loaded context objects.
    #
    # @example
    #   Contextify.load_contexts('/path/to/misc_contexts.rb')
    #   # => [...]
    #
    def Contextify.load_contexts(path,&block)
      new_objs = []

      Contextify.load_blocks(path) do |pending|
        pending.each_block do |name,context_block|
          if Contextify.is_context?(name)
            new_obj = Contextify.contexts[name].new
            new_obj.instance_eval(&context_block)

            block.call(new_obj) if block
            new_objs << new_obj
          end
        end
      end

      return new_objs
    end
  end
end
