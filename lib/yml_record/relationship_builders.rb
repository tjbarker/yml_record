require 'yml_record/relationship_builders/belongs_to.rb'

module YmlRecord
  module RelationshipBuilders
    def self.belongs_to(*args, **opts, &block)
      BelongsTo.build(*args, **opts, &block)
    end
  end
end
