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
  end
end
