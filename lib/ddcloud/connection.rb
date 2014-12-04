module DDcloud
  module Connection
    def build_request(type, endpoint, query = nil, body = nil, xml=true)
      # url = "https://cloudapi.nttamerica.com/oec/0.9" + "/server"
      uri = api_base + endpoint
      append_query(uri, query) if query

      if xml
        request = Typhoeus::Request.new(
          uri,
          method: type,
          body: body,
          userpwd: "#{@username}:#{@password}",
            headers: { 'Content-Type' =>'text/xml', 'User-Agent' => 'ACP Ruby SDK' }
        )
      else
        request = Typhoeus::Request.new(
          uri,
          method: type,
          body: body,
          userpwd: "#{@username}:#{@password}",
            headers: {  'User-Agent' => 'ACP Ruby SDK' }
        )
      end
    end

    def append_query(uri, query)
      if uri.include?('?')
        uri << '&'
      else
        uri << '?'
      end
      uri << query
    end


    def perform_request(request)
      log "\nrequesting #{request.url}...", :yellow
      request.run
    end

    def log_response(request, response)
      if response.success?
        log "...........success!", :yellow
      elsif response.timed_out?
        log "ERROR\n-----", :red
        log "got a time out"
      elsif response.code == 0
        # Could not get an http response, something's wrong.
        log "ERROR\n-----", :red
        log response.return_message
      else
        # Received a non-successful http response.
        log "ERROR\n-----", :red
        log "HTTP request failed: " + response.code.to_s, :red
        log response.body, :yellow
      end
    end
  end
end
