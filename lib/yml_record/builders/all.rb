module YmlRecord
  module Builders 
    module All
      def all
        @all ||= relation_klass.new(data.map { |op| new(**op.symbolize_keys) })
      end

      delegate_missing_to :all
    end
  end
end
