require 'secure_headers'

module CoalescingPanda
  class Engine < ::Rails::Engine
    config.autoload_once_paths += Dir["#{config.root}/lib/**/"]
    isolate_namespace CoalescingPanda

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

    initializer :secure_headers do |app|
      connect_src = %w('self')
      script_src = %w('self')
      if Rails.env.development?
        # Allow webpack-dev-server to work
        connect_src << "http://localhost:3035"
        connect_src << "ws://localhost:3035"
        # Allow stuff like rack-mini-profiler to work in development:
        # https://github.com/MiniProfiler/rack-mini-profiler/issues/327
        # DON'T ENABLE THIS FOR PRODUCTION!
        script_src << "'unsafe-eval'"
      end

      # SecureHeaders::Configuration.default do |config|
      #   # The default cookie headers aren't compatible with PandaPal cookies currently
      #   config.cookies = { samesite: { none: true } }
      #   if Rails.env.production?
      #     config.cookies[:secure] = true
      #   end
      #   # Need to allow LTI iframes
      #   config.x_frame_options = "ALLOWALL"
      #   config.x_content_type_options = "nosniff"
      #   config.x_xss_protection = "1; mode=block"
      #   config.referrer_policy = %w(origin-when-cross-origin strict-origin-when-cross-origin)
      #   config.csp = {
      #       default_src: %w('self'),
      #       script_src: script_src,
      #       # Certain CSS-in-JS libraries inline the CSS, so we need to use unsafe-inline for them
      #       style_src: %w('self' 'unsafe-inline' blob: https://fonts.googleapis.com),
      #       font_src: %w('self' data: https://fonts.gstatic.com),
      #       connect_src: connect_src,
      #   }
      # end

      SecureHeaders::Configuration.override(:safari_override) do |config|
        config.cookies = SecureHeaders::OPT_OUT
      end

    end
  end
end
