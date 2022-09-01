module YmlRecord
  module Pluralize
    #TODO: implement this properly
    def self.call(string)
      "#{string}s"
    end
  end

  module Builders
    module Enum

      # will define:
      # - the list of keys on class
      # - for each enum value a check method, e.g: Class.new.key? => Boolean
      # - for each enum value a class scope, e.g: Class.key => relation
      # singular true => Class.key will return first instance with value
      # singular false => Class.key will return a relation of instances with value
      def enum(key, singular: false)
        key = key.to_s
        plural = Pluralize.call(key)

        define_singleton_method plural do
          all.inject([]) do |acc, d|
            acc << d.send(key)
          end.uniq.compact
        end

        send(plural).each do |value|
          define_method "#{value}?" do
            send(key) == value
          end

          define_singleton_method value do
            send(singular ? :find_by : :where, key.to_sym => value)
          end
        end
      end
    end
  end
end
