require 'objectify/exceptions/object_not_found'
require 'objectify/class_methods'
require 'objectify/pending_object'

module Objectify
  def self.included(base)
    base.extend ClassMethods
  end

  #
  # The contexts waiting to be fully loaded.
  #
  # @return [Array<PendingObject>]
  #   Contexts which are waiting to be loaded.
  #
  def Objectify.queue
    @@queue ||= []
  end

  #
  # The first context waiting to be fully loaded.
  #
  # @return [PendingObject]
  #   The pending context being loaded.
  #
  def Objectify.pending
    queue.first
  end

  #
  # Determines whether there are pending objects.
  #
  # @return [Boolean]
  #   Specifies whether there is a pending object present.
  #
  def Objectify.is_pending?
    !(queue.empty?)
  end

  #
  # Finds the first pending object being loaded from a specific path.
  #
  # @param [String] path
  #   The path which is being loaded.
  #
  # @return [PendingObject]
  #   The first pending object with the specified path.
  #
  def Objectify.loading(path)
    queue.find { |pending| pending.path == path }
  end

  #
  # Determines whether contexts are being loaded from a specific path.
  #
  # @param [String] path
  #   The path to check if contexts are being loaded from.
  #
  # @return [Boolean]
  #   Specifies whether pending objects are being loaded from the
  #   specified path.
  #
  def Objectify.is_loading?(path)
    !(loading(path).nil?)
  end

  #
  # Loads all context blocks from a specific path.
  #
  # @param [String] path
  #   The path to load all context blocks from.
  #
  # @return [PendingObject]
  #   The pending object which contains the blocks.
  #
  def Objectify.load_blocks(path)
    path = File.expand_path(path)

    unless File.file?(path)
      raise(ObjectNotFound,"context #{path.dump} doest not exist",caller)
    end

    # prevent circular loading of contexts
    unless is_pending?
      # push on the new pending object
      queue.unshift(PendingObject.new(path))

      begin
        load(path)
      rescue Exception => e
        # if any error is encountered, pop off the context
        queue.shift
        raise(e)
      end
    end

    # pop off and return the pending context
    pending_object = queue.shift

    yield pending_object if block_given?
    return pending_object
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
  def Objectify.load_objects(path)
    new_objects = []

    load_blocks(path) do |pending|
      pending.each do |klass,block|
        new_object = klass.new
        new_object.instance_eval(&block)

        yield new_object if block_given?
        new_objects << new_object
      end
    end

    return new_objects
  end
end
