require 'yml_record/base'
require "yml_record/version"

module YmlRecord
  class Error < StandardError; end

  def relationships
    RelationshipBuilder
  end
end
