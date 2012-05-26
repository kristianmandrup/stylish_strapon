require 'stylish_strapon/stylesheets/builder'

module StylishStrapon
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      argument :indexes, :type => :array,   :default => ['basic', 'ricco'], :desc => "Index yml files to use as templates for stylesheet generation"

      class_option :path, :type => :string, :desc => %q{Path to stylesheet_index.yml to be used to copy stylesheets.
Allows finer control of which styles to copy into project}

      class_option :gemfile, :type => :boolean, :default => false, :desc => "Update gemfile?"
    
      def run_generation
        say "Styling your app with: #{indexes}"

        #css design structure
        remove_file "app/assets/stylesheets/application.css"
        copy_file "stylesheets/application.css.sass", "app/assets/stylesheets/application.css.sass"

        copy_stylesheets :path => options[:path], :indexes => indexes

        update_gemfile if update_gemfile?
      end

      protected

      # include StylishStrapon::Stylesheets::Builder

      def bundle_warning!
        puts "#{'*'*70}"
        puts ""
        puts "remember to run"
        puts "bundle"
        puts ""
        puts "#{'*'*70}"
      end

      def path
        @path ||= File.dirname(__FILE__) + '/stylesheet_index.yml'
      end

      def update_gemfile?
        options[:gemfile]
      end

      def update_gemfile
        # # Gemfile
        inject_into_file "Gemfile", :after => /^.*gem 'jquery-rails.*\n/ do
           %q{#HTML generation and css
gem 'high_voltage'
gem 'haml'}
        end

        inject_into_file "Gemfile", :after => /^.*group :assets do*\n/ do
          %q{  gem 'compass-rails'
  gem 'bootstrap-sass'}
        end

        bundle_warning!
      end        
    end
  end
end
