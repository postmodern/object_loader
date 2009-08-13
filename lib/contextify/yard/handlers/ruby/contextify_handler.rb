require 'yard'

module YARD
  module Handlers
    module Ruby
      class ContextifyHandler < Base

        handles method_call(:contextify)

        def process
          nobj = ModuleObject.new(:root, 'Kernel')
          obj = statement.parameters(false).first

          mscope = scope
          name = case obj.type
          when :symbol_literal
            obj.jump(:ident, :op, :kw, :const).source
          when :string_literal
            obj.jump(:string_content).source
          end

          register MethodObject.new(nobj, name, mscope) do |o|
            o.visibility = :public
            o.source = statement.source
            o.signature = "def #{name}(&block)"
            o.parameters = [['&block', nil]]
          end
        end

      end
    end
  end
end
