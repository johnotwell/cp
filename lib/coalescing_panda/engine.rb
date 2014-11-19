module CoalescingPanda
  class Engine < ::Rails::Engine
    config.autoload_once_paths += Dir["#{config.root}/lib/**/"]
    isolate_namespace CoalescingPanda

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    initializer 'coalescing_panda.app_controller' do |app|
      OAUTH_10_SUPPORT = true
      ActiveSupport.on_load(:action_controller) do
        include CoalescingPanda::ControllerHelpers
      end
    end

    initializer 'cloaescing_panda.route_helper' do |route|
      ActionDispatch::Routing::Mapper.send :include, CoalescingPanda::RouteHelpers
    end

    initializer 'coalescing_panda.route_options', :after => :disable_dependency_loading do |app|
      ActiveSupport.on_load(:action_controller) do
        #force the routes to load
        Rails.application.reload_routes!
        CoalescingPanda::propagate_lti_navigation
      end
    end

  end
end
