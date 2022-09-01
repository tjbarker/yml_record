module YmlRecord
  module Builders
    module DataLoader
      protected

      def data
        @data ||= YAML.load_file(filelocation)
      end

      private

      attr_writer :filename, :filepath, :primary_key

      def filename
        @filename ||= name.demodulize.underscore
      end

      def filepath
        @filepath || default_filepath 
      end

      def filepath=(fp)
        @filepath = fp
      end

      def default_filepath
        'config/data'
      end

      def filelocation
        @filelocation || default_filelocation
      end

      def filelocation=(fl)
        @filelocation = fl
      end

      def default_filelocation
        "#{filepath}/#{filename}.#{filetype}"
      end

      def filetype
        'yml'
      end
    end
  end
end
