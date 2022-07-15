require 'active_support/core_ext/string'

module YmlRecord
  module RelationshipBuilders
    class BelongsTo
      def self.build(model, name, scope = nil, **options, &_block)
        new(model, name, scope, **options).build
      end

      def initialize(model, name, scope, dynamic: true, **options)
        @model = model
        @name = name
        raise(NotImplementedError, 'yml record belongs to with scope is not yet implemented') if !!scope
        @dynamic = dynamic
        @options = options
      end

      def build
        klass = (options.fetch(:class_name, nil) || name.to_s.camelize).constantize
        klass_primary_key = options.fetch(:primay_key, klass.primary_key)
        foreign_key = options.fetch(:foreign_key, "#{name}_#{klass_primary_key}")

        model.define_method name do
          klass.find_by(klass_primary_key => send(foreign_key))
        end

        if dynamic
          model.define_method "#{name}=" do |instance|
            self.send("#{foreign_key}=", instance.send(klass_primary_key))
          end
        end
      end

      private

      attr_reader :model, :name, :dynamic, :options
    end
  end
end
