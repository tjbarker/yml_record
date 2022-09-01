module YmlRecord
  module Builders 
    module HasAttributes
      def initialize(**data)
        @attributes = Attributes.new(**data)
      end

      delegate_missing_to :attributes

      private

      attr_reader :attributes
    end
  end
end
