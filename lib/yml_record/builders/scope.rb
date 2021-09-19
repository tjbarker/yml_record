module YmlRecord
  module Builders 
    module Scope
      def scope(name, body, &_block)
        body.respond_to?(:call) || raise(ArgumentError, 'The scope body needs to be callable.')
        block_given? && raise(NotImplementedError, 'Scopes do not handle extension.')

        relation_klass.define_method name do
          instance_exec(&body)
        end
      end
    end
  end
end
