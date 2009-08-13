require 'yard'

module YARD
  module Handlers
    module Ruby
      module Legacy
        class ContextifyHandler < Base

          handles /\Acontextify\s/

          def process
            nobj = ModuleObject.new(:root, 'Kernel')

            mscope = scope
            name = statement.tokens[2,1].to_s[1..-1]

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
end
