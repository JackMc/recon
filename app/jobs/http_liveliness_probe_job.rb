class HttpLivelinessProbeJob < ApplicationJob
  queue_as :default

  def perform(domain_id:, scan_id: nil, path: '/')
    domain = Domain.find(domain_id)

    http = RawHttp.new(host: domain.fqdn, port: 443, use_https: true, verify: false)
    response = http.send(uri: path)

    HttpProbe.create!(
      domain: domain,
      http_response: response.raw,
      http_request: response.raw_request,
      url: path,
      status_code: response.status_code,
      status_name: response.status_name,
      https: response.use_https,
      body: response.body,
      headers: response.headers,
      scan_id: scan_id,
      failed: false,
      failure_reason: nil
    )
  rescue Errno::ETIMEDOUT, SocketError, Errno::ECONNREFUSED, OpenSSL::SSL::SSLError => e
    HttpProbe.create!(
      domain: domain,
      url: path,
      scan_id: scan_id,
      failed: true,
      failure_reason: e.message
    )
  end
end
