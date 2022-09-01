require 'yaml'
require 'active_support/core_ext/module/delegation.rb'
require 'yml_record/relation.rb'
require 'yml_record/attributes.rb'
require 'yml_record/builders/enum.rb'
require 'yml_record/builders/scope.rb'
require 'yml_record/builders/data_loader.rb'
require 'yml_record/builders/all.rb'
require 'yml_record/builders/has_attributes.rb'

module YmlRecord
  class Base
    include Builders::HasAttributes

    class << self
      include Builders::DataLoader
      include Builders::All # Includes a delegate_missing_to_all
      include Builders::Enum
      include Builders::Scope

      def primary_key
        @primary_key ||= 'id'
      end

      def reset_data
        @data = nil
        data
      end

      protected

      def boolean_columns(*keys)
        raise NotImplementedError, 'this method is no longer necessary, data with a boolean value automatically generates a `?` getter'
      end

      private

      attr_writer :primary_key

      def relation_klass
        @relation_klass ||= const_set('Relation', Class.new(Relation))
      end
    end

    def ==(other)
      other.send(:__identifier) == __identifier
    end

    # for inheritor to overwrite if other means of equating is necessary
    def __identifier
      respond_to?(:id) ? "id-#{id}" : "hash-#{hash}"
    end
  end
end
