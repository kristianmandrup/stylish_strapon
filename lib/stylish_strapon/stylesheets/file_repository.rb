require 'stylish_strapon/stylesheet'
require 'hashie'
require 'yaml'

module StylishStrapon
  module Stylesheets
    class FileRepository
      attr_reader :path, :indexes

      def initialize options = {}
        indexes = options[:indexes]
        path = options[:path]

        raise ArgumentError, "No valid file path, was: #{path}" unless path && File.exist?(path)
        raise ArgumentError, "No index files" unless indexes && indexes.kind_of?(Array)
        @indexes = indexes
        @path = path unless path.blank?
      end

      def stylesheets
        @stylesheets ||= {}
      end

      def load_stylesheets index
        @load_stylesheets ||= ::Hashie::Mash.new(yaml_content(index)).stylesheets
      end

      def yaml_content index
        YAML.load_file File.join(path, index)
      end

      def build
        indexes.each do |index|
          load_stylesheets(index).each_pair do |key, value|
            case value
            when String
              add_stylesheet key, "#{value}_#{key}", key
            when Hash
              build_from_hash key, value
            end
          end
        end
        self
      end

      def build_from_hash key, hash
        index = hash[:index]
        raise ArgumentError, "The entry #{key}: is missing index:" unless index
        files = get_files(hash).compact
        raise ArgumentError, "The entry #{key}: is missing file: or files: key" if files.empty?
        files.flatten.each do |file|
          add_stylesheet key, "#{index}_#{key}", file
        end
      end

      def get_files hash
        [hash[:file] || hash[:files]]
      end

      def add_stylesheet key, path, name
        stylesheets[key] ||= []
        stylesheets[key] << StylishStrapon::Stylesheet.new(name, path)
      end
    end
  end
end