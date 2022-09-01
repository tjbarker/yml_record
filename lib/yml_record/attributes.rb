require 'ostruct'

module YmlRecord
  # class to hold attributes, just hold and return for now
  class Attributes
    delegate_missing_to :store

    def initialize(**opts)
      new_opts = opts.each_with_object({}) do |(key, value), acc|
        if [true, false].include?(value) && !key.to_s.end_with?('?')
          acc["#{key}?".to_sym] = value
        end
        acc[key] = value
      end
      @store = OpenStruct.new(new_opts)
    end

    private

    attr_reader :store
  end
end
