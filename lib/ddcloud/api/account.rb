module DDcloud::API
  class Account < Core
    def myaccount()
      endpoint "/myaccount"
      get
    end

    def list()
      org_endpoint "/account"
      get
    end
  end
end
