require "coalescing_panda/engine" if defined?(Rails)
require "coalescing_panda/navigation"
require 'ims/lti'
require 'bearcat'
require 'oauth/request_proxy/rack_request'

module CoalescingPanda
  class LtiNavigationInUse < StandardError;end
  class NotMounted < StandardError;end

  @@lti_navigation = {}
  @@staged_navigation = {}
  @@lti_options

  def self.lti_options= lti_options
    @@lti_options = lti_options
  end

  def self.lti_options
    @@lti_options.deep_dup
  end

  def self.register_navigation(navigation)
    @@lti_navigation[navigation] = {}
  end

  def self.stage_navigation(navigation, options)
    @@staged_navigation[navigation] = {} unless @@staged_navigation.has_key?(navigation)
    @@staged_navigation[navigation].merge!(options)
  end

  def self.lti_paths
    @@lti_navigation.deep_dup
  end

  def self.propagate_lti_navigation
    @@staged_navigation.each do |k,v|
      lti_navigation(k,v)
      @@staged_navigation.delete(k)
    end
  end

  private

  def self.lti_navigation(navigation, options)
    raise "lti navigation '#{navigation}' has not been registered!" unless @@lti_navigation.has_key?(navigation)
    @@lti_navigation[navigation].merge!(options)
  end

end

