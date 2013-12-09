module CoalescingPanda
  class Engine < ::Rails::Engine
    config.autoload_once_paths += Dir["#{config.root}/lib/**/"]
    isolate_namespace CoalescingPanda

    initializer 'coalescing_panda.app_controller' do |app|
      OAUTH_10_SUPPORT = true
      ActiveSupport.on_load(:action_controller) do
        include CoalescingPanda::ControllerHelpers
      end
    end

    initializer 'cloaescing_panda.route_helper' do |route|
      ActionDispatch::Routing::Mapper.send :include, CoalescingPanda::RouteHelpers
    end

    initializer 'coalescing_panda.route_options' do |app|
      ActiveSupport.on_load(:disable_dependency_loading) do
        CoalescingPanda::propagate_lti_navigation
      end
    end
     
  end
end
