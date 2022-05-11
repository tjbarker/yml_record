require 'yml_record/base'
require "yml_record/version"
require 'yml_record/relationship_builders'

module YmlRecord
  class Error < StandardError; end

  def self.relationships
    YmlRecord::RelationshipBuilders
  end
end
