module DDcloud::API
  class Core
    attr_reader :client
    def initialize(client)
      @client = client
    end


    ### client methods

    def log(*args)
      @client.log(*args)
    end

    def org_id
      @client.org_id
    end


    ### request options

    def endpoint(e)
      @endpoint = e
    end

    def org_endpoint(e)
      endpoint("/#{org_id}" + e)
    end

    def query_params(q)
      @query_params = q
    end

    def xml_params(x)
      @xml_params = x
    end

    def simple_params(x)
      @simple_params = x
    end

    ### perform request

    def get
      perform :get
    end

    def post
      perform :post
    end

    def get_simple
        perform :get, true
    end

    def post_simple
        perform :post, true
    end

    #do not parse response if simple
    #if simple, post body is also simple...
    def perform(method, simple=false)
      if simple
        request = @client.build_request(method, @endpoint, request_query_string, request_simple_body, false)
      else
        request = @client.build_request(method, @endpoint, request_query_string, request_xml_body)
      end
      response = @client.perform_request(request)

      @client.log_response(request, response)

      # return parsed object if it's good
      if response.success?
        if simple
          result = response.body
        else
          result = @client.parse_response_xml_body(response.body)
          if result['total_count']
            log "#{result['total_count']} total", :yellow, :bold
            result.delete('page_size')
            result.delete('total_count')
            result.delete('page_count')
            result.delete('page_number')
          end
          # unwind some arrays of elements
          result.values.count == 1 ? result.values.first : result
        end
      else
        {}
      end
    end

    def single(results)
      if results.is_a? Array
        results.first
      else
        results
      end
    end


    ### build request

    def request_query_string
      fparams = @client.filter_params || {}
      qparams = @query_params || {}
      params = fparams.merge(qparams)
      @client.url_query(params) if params.present?
    end

    def request_xml_body
      return if @xml_params.blank?
      schema = @xml_params.delete(:schema)
      tag = @xml_params.delete(:tag)

      body = @client.build_request_xml_body(schema, tag, @xml_params)
      log(body, :green)
      body
    end
    def request_simple_body
      return if @simple_params.blank?
      body = @client.build_request_simple_body(@simple_params)
      log(body, :green)
      body
    end
  end
end
