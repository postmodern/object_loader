require 'yard/handlers/ruby/base'

module YARD
  module Handlers
    module Ruby
      class ContextifyHandler < Base

        handles :contextify, method_call(:contextify)

        def process
          nobj = 'Kernel'
          mscope = scope
          name = if statement.type == :contextify
                   statement.jump(:ident, :op, :kw, :const).source
                 elsif statement.call?
                   obj = statement.parameters(false).first

                   case obj.type
                   when :symbol_literal
                     obj.jump(:ident, :op, :kw, :const).source
                   when :string_literal
                     obj.jump(:string_content).source
                   end
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
