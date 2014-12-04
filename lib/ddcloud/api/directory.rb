module DDcloud::API
  class Directory < Core
    def data_center_list
      org_endpoint "/datacenterWithDiskSpeed"
      get
    end
  end
end
