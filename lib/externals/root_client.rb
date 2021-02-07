class RootClient
  include HTTParty
  def initialize(opts = {})
    @headers = headers
  end

  def headers
    {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end

  def url_with_service(service)
      URI.encode("#{base_url}/#{service}")
  end

  def get_opts(opts = {})
    opts_payload = {
      headers: @headers,
    }
    opts_payload.merge!(opts)
  end

  def base_url
    raise StandardError, 'Abstract Method, please define in client.'
  end

  def http(action, service, opts = {})
    full_url = self.url_with_service(service)
    options = self.get_opts(opts)
    response = HTTParty.send(action, full_url, options)
    response
  end

  def get(service, opts = {})
    self.http(:get, service, opts)
  end

  def post(service, opts = {})
    self.http(:post, service, opts)
  end
end