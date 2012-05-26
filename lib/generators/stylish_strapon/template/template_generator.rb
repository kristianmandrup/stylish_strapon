module StylishStrapon
  module Generators
    class TemplateGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../../install", __FILE__)

      argument :templates, :type => :array,   :default => [:basic, :ricco], :desc => %q{Templates to copy}

      def run_generation
        say "Copying template: #{templates}"
        templates.each do |template|
          copy_file "indexes/#{template}.yml", ::Rails.root.join("#{template}.yml")
        end
      end
    end
  end
end

