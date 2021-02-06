class RawHttp
  class InvalidHttpResponseException < Exception; end

  class Response
    attr_accessor :host, :port, :use_https, :uri, :status_code, :status_name, :headers, :body, :raw_body, :raw, :raw_request
    alias :status :status_code

    def inspect
      "<#{status_code} #{status_name} response from #{host}:#{port}>"
    end
  end
  
  STATUS_LINE_REGEX = %r{\AHTTP/1\.1 ([0-9]+) ([A-Za-z0-9 ]+)\r\n}
  HEADER_REGEX = %r{\A([a-zA-Z\-0-9]+): ?(.*)\r\n}
  attr_accessor :host, :port, :use_https, :headers, :verify

  def initialize(host:, port: 80, use_https: false, verify: true)
    @host = host
    @port = port
    @use_https = use_https
    @headers = {
      'User-Agent' => 'RawHTTP'
    }
    @verify = verify
  end

  def send(uri:, method: 'GET')
    @response = Response.new
    @response.host = host
    @response.port = port
    @response.uri = uri
    @response.use_https = use_https
    @response.raw = ''
    @response.raw_request = ''

    socketputs "#{method} #{uri} HTTP/1.1"
    socketputs "Host: #{host}"
    headers.each do |header, value|
      socketputs "#{header}: #{value}"
    end
    socketputs
    socketputs

    # HTTP/1.1 200 OK
    status_line = socketgets
    status_code, status_name = STATUS_LINE_REGEX.match(status_line).captures
    @response.status_name = status_name
    @response.status_code = status_code.to_i
    response_headers = {}
    raw_request = status_line


    while line = socketgets
      raw_request << line
      break if line == "\r\n"

      header, value = HEADER_REGEX.match(line).captures
      response_headers[header.downcase] = value
    end

    @response.headers = response_headers

    if content_length = response_headers['content-length']
      body = socketread(content_length.to_i)
      @response.body = @response.raw_body = body
    elsif transfer_encoding = response_headers['transfer-encoding']
      processed_body = ""
      raw_body = ""
      raise InvalidHttpResponseException,
        "Unsupported transfer-encoding: #{transfer_encoding}" unless transfer_encoding == 'chunked'

      length_str = socketgets
      length = length_str.to_i(16)
      while length != 0
        body_piece = socketread(length)
        raw_body << length_str
        raw_body << body_piece
        processed_body << body_piece

        # Each body piece has a \r\n after it
        raw_body << socketgets
        length_str = socketgets
        length = length_str.to_i(16)
      end

      @response.body = processed_body
      @response.raw_body = raw_body
    elsif @response.status == 204
      Rails.logger.info "Not parsing response body for headerless 204."
    else
      raise InvalidHttpResponseException, "No Content-Length or Transfer-Encoding"
    end

    @response
  ensure
    socket&.close
    @socket = nil
  end

  def socket
    return @socket if @socket

    raw_socket = Socket.tcp(host, port, connect_timeout: 5, resolv_timeout: 5)
    return @socket = raw_socket unless use_https

    ctx = OpenSSL::SSL::SSLContext.new
    cert_store = OpenSSL::X509::Store.new
    cert_store.set_default_paths
    ctx.cert_store = cert_store
    ctx.set_params(verify_mode: verify_mode)
    return @socket = OpenSSL::SSL::SSLSocket.new(raw_socket, ctx).tap do |socket|
      socket.sync_close = true
      socket.connect
    end
  end

  def verify_mode
    if verify
      OpenSSL::SSL::VERIFY_PEER
    else
      OpenSSL::SSL::VERIFY_NONE
    end
  end

  def socketgets
    socket.gets.tap do |line|
      @response.raw << line
    end
  end

  def socketread(bytes)
    socket.read(bytes).tap do |bytes|
      @response.raw << bytes
    end
  end

  def socketputs(str='')
    @response.raw_request << str
    @response.raw_request << "\r\n"

    socket.puts(str)
  end
end
