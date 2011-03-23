require 'object_loader/exceptions/object_not_found'
require 'object_loader/class_methods'
require 'object_loader/pending_object'

module ObjectLoader
  #
  # Includes {ClassMethods} into the class.
  #
  # @param [Class] base
  #   The class that {ObjectLoader} is being included into.
  #
  def self.included(base)
    base.extend ClassMethods
  end

  #
  # The pending objects waiting to be fully loaded.
  #
  # @return [Array<PendingObject>]
  #   Contexts which are waiting to be loaded.
  #
  # @since 1.0.0
  #
  def ObjectLoader.queue
    @@queue ||= []
  end

  #
  # The first pending object waiting to be fully loaded.
  #
  # @return [PendingObject]
  #   The pending object being loaded.
  #
  # @since 1.0.0
  #
  def ObjectLoader.pending
    queue.first
  end

  #
  # Determines whether there are pending objects.
  #
  # @return [Boolean]
  #   Specifies whether there is a pending object present.
  #
  # @since 1.0.0
  #
  def ObjectLoader.is_pending?
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
  # @since 1.0.0
  #
  def ObjectLoader.loading(path)
    queue.find { |pending| pending.path == path }
  end

  #
  # Determines whether objects are being loaded from a specific path.
  #
  # @param [String] path
  #   The path to check if objects are being loaded from.
  #
  # @return [Boolean]
  #   Specifies whether pending objects are being loaded from the
  #   specified path.
  #
  # @since 1.0.0
  #
  def ObjectLoader.is_loading?(path)
    !(loading(path).nil?)
  end

  #
  # Loads all object blocks from a specific path.
  #
  # @param [String] path
  #   The path to load all object blocks from.
  #
  # @return [PendingObject]
  #   The pending object which contains the blocks.
  #
  # @since 1.0.0
  #
  def ObjectLoader.load_blocks(path)
    path = File.expand_path(path)

    unless File.file?(path)
      raise(ObjectNotFound,"#{path.dump} doest not exist",caller)
    end

    # prevent circular loading of objects
    unless is_pending?
      # push on the new pending object
      queue.unshift(PendingObject.new(path))

      begin
        load(path)
      rescue Exception => e
        # if any error is encountered, pop off the object
        queue.shift
        raise(e)
      end
    end

    # pop off and return the pending object
    pending_object = queue.shift

    yield pending_object if block_given?
    return pending_object
  end

  #
  # Loads all objects from a specific path.
  #
  # @param [String] path
  #   The path to load all objects from.
  #
  # @return [Array]
  #   The array of loaded objects.
  #
  # @example
  #   ObjectLoader.load_objects('/path/to/misc_object.rb')
  #   # => [...]
  #
  # @since 1.0.0
  #
  def ObjectLoader.load_objects(path)
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
