require 'yml_record/helpers/delegate_missing_to.rb'

module YmlRecord
  module Builders 
    module All
      extend DelegateMissingTo

      def all
        @all ||= relation_klass.new(data.map { |op| new(**op) })
      end

      delegate_missing_to :all
    end
  end
end
