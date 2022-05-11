module YmlRecord
  module Builders
    module DataLoader
      protected

      def data
        @data ||= abstract_class ? [] : YAML.load_file(filepath)
      end

      private

      attr_writer :filename, :filepath, :primary_key

      def filename
        @filename ||= name.demodulize.snakecase
      end

      def filepath
        @filepath ||= 'config/data'
      end

      def filelocation
        @filelocation ||= "#{filepath}/#{filename}.yml"
      end
    end
  end
end
