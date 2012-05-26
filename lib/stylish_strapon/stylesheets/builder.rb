require 'stylish_strapon/stylesheets/file_repository'

module StylishStrapon
  module Stylesheets
    module Builder
      def copy_stylesheets options = {}
        # puts "stylesheets: #{stylesheets(options)}"
        stylesheets(options).each_pair do |folder, stylesheet_list|
          stylesheet_list.each do |stylesheet|
            puts "stylesheet: #{stylesheet}"
            copy_stylesheet stylesheet
          end
        end
      end

      def stylesheets options = {}
        @stylesheets ||= StylishStrapon::Stylesheets::FileRepository.new(options).build.stylesheets
      end

      def copy_stylesheet stylesheet
        copy_file stylesheet_path(:src, stylesheet), stylesheet_path(:target, stylesheet)
      end

      def stylesheet_path type, stylesheet
        File.join send("#{type}_stylesheet_dir"), stylesheet.path, "_#{stylesheet.name}.#{stylesheet_ext type}"
      end

      def stylesheet_ext type
        type == :target ? 'css.sass' : 'sass'
      end

      def src_stylesheet_dir
        'stylesheets/site/'
      end

      def target_stylesheet_dir
        File.join "app/assets/", src_stylesheet_dir
      end
    end
  end
end