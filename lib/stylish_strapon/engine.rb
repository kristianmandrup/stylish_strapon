module StylishStrapon
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace StylishStrapon
      
      # config.generators.integration_tool    :rspec
      # config.generators.test_framework      :rspec
    end
  end
end