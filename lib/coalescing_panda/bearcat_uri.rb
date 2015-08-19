class CoalescingPanda::BearcatUri
  attr_accessor :uri

  def initialize(uri)
    Rails.logger.info "Parsing Bearcat URI: #{uri}"
    @uri = URI.parse(uri)
  end

  def api_domain
    uri.port.present? ? URI.encode("#{uri.host}:#{uri.port.to_s}") : uri.host
  end

  def scheme
    [uri.scheme, '://'].join
  end

  def prefix
    [scheme, api_domain].join
  end
end