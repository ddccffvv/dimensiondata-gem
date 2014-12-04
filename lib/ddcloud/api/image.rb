module DDcloud::API
  class Image < Core
    def server_list
      endpoint '/base/image'
      get
    end

    def deployed_list(options = {})
      endpoint "/#{org_id}/image/deployed"
      query_params options
      get
    end

    def show_by_name(name, options = {})
      options[:name] = name
      single(deployed_list(options))
    end

    def show(image_id)
      endpoint "/#{org_id}/image/#{image_id}"
      get
    end
  end
end
