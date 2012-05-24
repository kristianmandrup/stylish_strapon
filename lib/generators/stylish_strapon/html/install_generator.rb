require 'stylish_strapon/stylesheets/builder'

module StylishStrapon
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      class_option :path, :type => :string, :desc => %q{Path to stylesheet_index.yml to be used to copy stylesheets.
Allows finer control of which styles to copy into project}

      class_option :gemfile, :type => :boolean, :default => false, :desc => %q{Update gemfile?}

      class_option :indexes, :type => :array,   :default => [], :desc => %q{Index yml files to use as templates for stylesheet generation}

      def run_generation
        say "Styling your app with: #{indexes}"

        #css design structure
        remove_file "app/assets/stylesheets/application.css"
        copy_file "stylesheets/application.css.sass", "app/assets/stylesheets/application.css.sass"

        copy_stylesheets :path => options[:path], :indexes => indexes

        update_gemfile if update_gemfile?
      end

      protected

      def bundle_warning!
        puts "#{'*'*70}"
        puts ""
        puts "remember to run"
        puts "bundle"
        puts ""
        puts "#{'*'*70}"
      end

      def indexes
        options[:indexes] || ['basic', 'ricco']
      end

      def path
        @path ||= File.dirname(__FILE__) + '/stylesheet_index.yml'
      end

      def update_gemfile?
        options[:gemfile]
      end

      def update_gemfile
        # Gemfile
        inject_into_file "Gemfile", :after => /^.*gem 'jquery-rails.*\n/ do
          "\n#HTML generation and css\n"+
          "gem 'high_voltage'\n"+
          "gem 'haml'\n"+
        end

        inject_into_file "Gemfile", :after => /^.*group :assets do*\n/ do
          "  gem 'compass-rails'\n"+
          "  gem 'bootstrap-sass'\n"
        end

        bundle_warning!
      end        

      include StylishStrapon::Stylesheets::Builder
    end
  end
end
