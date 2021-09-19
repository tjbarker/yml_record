require 'yml_record/helpers/delegate_missing_to.rb'

module YmlRecord
  module Builders 
    module HasAttributes
      extend DelegateMissingTo

      def initialize(**data)
        @attributes = Attributes.new(**data)
      end

      delegate_missing_to :attributes

      private

      attr_reader :attributes
    end
  end
end
