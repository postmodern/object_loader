require 'contextify/exceptions/unknown_context'
require 'contextify/exceptions/context_not_found'
require 'contextify/pending_context'
require 'contextify/extensions/meta'

module Contextify
  def self.included(base)
    base.module_eval do
      def self.contextify(name)
        name = name.to_sym

        Contextify.contexts[name] = self

        meta_def(:context_name) { name }

        meta_def(:load_context) do |path,*args|
          Contextify.load_context(self.context_name,path,*args)
        end

        # define the top-level context wrappers
        Kernel.module_eval %{
          def #{name}(*args,&block)
            if (args.empty? && ::Contextify.is_pending?)
              ::Contextify.pending.blocks[:#{name}] = block
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
    # Returns a Hash of all defined contexts.
    #
    def Contextify.contexts
      @@contextify_contexts ||= {}
    end

    #
    # Returns +true+ if there is a context defined with the specified
    # _name_, returns +false+ otherwise.
    #
    def Contextify.is_context?(name)
      Contextify.contexts.has_key?(name.to_sym)
    end

    #
    # Returns the Array of contexts which are waiting to be loaded.
    #
    def Contextify.waiting
      @@contextify_waiting_contexts ||= []
    end

    #
    # Returns the pending context being loaded.
    #
    def Contextify.pending
      Contextify.waiting.first
    end

    #
    # Returns +true+ if there is a pending context present, returns
    # +false+ otherwise.
    #
    def Contextify.is_pending?
      !(Contextify.waiting.empty?)
    end

    #
    # Returns the first pending context with the specified _path_.
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
    # Returns +true+ if the pending context with the specified _path_
    # is present, returns +false+ otherwise.
    #
    def Contextify.is_loading?(path)
      !(Contextify.loading(path).nil?)
    end

    #
    # Loads all context blocks from the specified _path_, returning a
    # PendingContext object containing the context blocks.
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
    # Loads the context block of the specified _name_ from the specified
    # _path_, returning the context block. If a _block_ is given it will
    # be passed the loaded context block.
    #
    #   Contextify.load_block('/path/to/my_exploit.rb',:exploit) # => Proc
    #
    #   Contextify.load_block('/path/to/my_shellcode.rb',:shellcode)
    #     do |block|
    #     ...
    #   end
    #
    def Contextify.load_block(name,path,&block)
      context_block = Contextify.load_blocks(path).blocks[name.to_sym]

      block.call(context_block) if block
      return context_block
    end

    #
    # Loads the context of the specified _name_ and from the specified
    # _path_ with the given _args_. If no contexts were defined with the
    # specified _name_, an UnknownContext exception will be raised.
    #
    #   Contextify.load_context(:note,'/path/to/my_notes.rb') # => Note
    #
    def Contextify.load_context(name,path,*args)
      name = name.to_sym

      unless Contextify.is_context?(name)
        raise(UnknownContext,"unknown context '#{name}'",caller)
      end

      new_context = Contextify.contexts[name].new(*args)

      Contextify.load_block(name,path) do |context_block|
        new_context.instance_eval(&context_block) if context_block
      end

      return new_context
    end

    #
    # Loads all contexts from the specified _path_ returning an +Array+
    # of loaded contexts. If a _block_ is given, it will be passed
    # each loaded context.
    #
    #   Contextify.load_contexts('/path/to/misc_contexts.rb') # => [...]
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
