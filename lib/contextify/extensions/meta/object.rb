# metaprogramming assistant -- metaid.rb
class Object
  # The hidden singleton lurks behind everyone
  def metaclass; class << self; self; end; end
  def meta_eval(&blk); metaclass.instance_eval(&blk); end

  # A class_eval version of meta_eval
  def metaclass_eval(&blk); metaclass.class_eval(&blk); end

  # A class_def version of meta_def
  def metaclass_def(name, &blk)
    metaclass_eval { define_method(name, &blk) }
  end
  
  # Adds methods to a metaclass
  def meta_def(name, &blk)
    meta_eval { define_method(name, &blk) }
  end
  
  # Defines an instance method within a class
  def class_def(name, &blk)
    class_eval { define_method(name, &blk) }
  end
end
