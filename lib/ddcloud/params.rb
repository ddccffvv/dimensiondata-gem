module DDcloud
  module Params
    def url_query(params)
      params = camelize_keys(params)
      qitems = []
      params.each do |k, vs|
        vs = [vs].flatten.compact # remove nil values
        vs.each {|v| qitems << "#{k}=#{v}"}
      end
      qitems.join('&')
    end

    def symbolize_keys(arg)
      case arg
      when Array
        arg.map {  |elem| symbolize_keys elem }
      when Hash
        Hash[
          arg.map {  |key, value|
            k = key.is_a?(String) ? key.to_sym : key
            v = symbolize_keys value
            [k,v]
          }]
      else
        arg
      end
    end

    def underscore_keys(arg)
      case arg
      when Array
        arg.map {  |elem| underscore_keys elem }
      when Hash
        Hash[
          arg.map {  |key, value|
            k = key.is_a?(String) ? key.underscore : key
            v = underscore_keys value
            [k,v]
          }]
      else
        arg
      end
    end

    def camelize_keys(arg)
      case arg
      when Array
        arg.map {  |elem| camelize_keys elem }
      when Hash
        Hash[
          arg.map {  |key, value|
            k = key.is_a?(String) ? key.camelize(:lower) : key
            k = key.is_a?(Symbol) ? key.to_s.camelize(:lower).to_sym : key
            v = camelize_keys value
            [k,v]
          }]
      else
        arg
      end
    end
  end
end
