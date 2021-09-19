require 'yml_record/helpers/delegate_missing_to.rb'

module YmlRecord
  class Relation
    extend DelegateMissingTo
    delegate_missing_to :list

    def initialize(list)
      @list = list
    end

    def where(**opts)
      self.class.new(opts.inject(list) do |list, (key, values)|
        list.select do |inst|
          value_list = values.nil? ? [nil] : Array(values)
          value_list.include?(inst.send(key))
        end
      end)
    end

    def find_by(**opts)
      where(**opts).first
    end

    def order(*keys, **keys_with_direction)
      direction_list = keys.inject(keys_with_direction) do |acc, key|
        { key => :asc }.merge(**acc)
      end

      self.class.new(list.sort_by do |inst|
        direction_list.map do |key, direction|
          direction == :asc ? inst.send(key) : -inst.send(key)
        end
      end)
    end

    def all
      self
    end

    private

    attr_reader :list
  end
end

