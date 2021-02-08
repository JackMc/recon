# frozen_string_literal: true
class ScreenshotJob < ApplicationJob
  queue_as :default

  def perform(http_probe_id:)
    http_probe = HttpProbe.find(http_probe_id)

    browser = Ferrum::Browser.new
    url = "https://#{http_probe.domain.fqdn}#{http_probe.url}"
    browser.goto(url)
    filesafe_website_name_with_extension = "#{url.gsub(%r{[:\./]+}, '_')}.png"
    filename = "tmp/screenshots/#{filesafe_website_name_with_extension}"
    browser.screenshot(path: filename)
    browser.quit

    http_probe.screenshot.attach(io: File.open(filename), filename: filesafe_website_name_with_extension,
content_type: 'image/png')
  end
end
