class HttpLivelinessProbeJob < ApplicationJob
  queue_as :default

  def perform(domain_id:, scan_id: nil, path: '/', screenshot: false)
    domain = Domain.find(domain_id)

    http = RawHttp.new(host: domain.fqdn, port: 443, use_https: true, verify: false)
    response = http.send(uri: path)

    probe = HttpProbe.create!(
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

    ScreenshotJob.perform_later(http_probe_id: probe.id) if screenshot
  rescue ActiveRecord::StatementInvalid => e
    probe = HttpProbe.create!(
      domain: domain,
      http_response: nil,
      http_request: nil,
      url: path,
      status_code: response.status_code,
      status_name: response.status_name,
      https: response.use_https,
      body: nil,
      headers: response.headers,
      scan_id: scan_id,
      failed: false,
      failure_reason: e.message
    )

    ScreenshotJob.perform_later(http_probe_id: probe.id) if screenshot
  rescue Errno::EHOSTUNREACH, Errno::ETIMEDOUT, SocketError, Errno::ECONNREFUSED, OpenSSL::SSL::SSLError => e
    HttpProbe.create!(
      domain: domain,
      url: path,
      scan_id: scan_id,
      failed: true,
      failure_reason: e.message
    )
  end
end
