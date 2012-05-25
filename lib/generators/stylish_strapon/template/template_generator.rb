module StylishStrapon
  module Generators
    class TemplateGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      argument :templates, :type => :array,   :default => [:basic, :rico], :desc => %q{Templates to copy}

      def run_generation
        say "Copying template: #{templates}"
        templates.each do |template|
          copy_file "templates/#{template}.yml", Rails.root
        end
      end

      protected

      def templates
        options[:templates]
      end
    end
  end
end

