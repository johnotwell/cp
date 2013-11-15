require "coalescing_panda/engine" if defined?(Rails)
require 'ims/lti'
require 'bearcat'
require 'oauth/request_proxy/rack_request'

module CoalescingPanda
  class LtiNavigationInUse < StandardError;end
  class NotMounted < StandardError;end

  @@lti_navigation = {}
  @@lti_options

  def self.lti_options= lti_options
    @@lti_options = lti_options
  end

  def self.lti_options
    @@lti_options.deep_dup
  end

  def self.lti_navigation(navigation, options)
    raise LtiNavigationInUse.new("#{navigation} can only be defined once") if @@lti_navigation.has_key?(navigation)
    @@lti_navigation[navigation] = options
  end

  def self.lti_paths
    @@lti_navigation.deep_dup
  end

end

