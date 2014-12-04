module DDcloud::API
  class VIP < Core

  # Real Server section
    def real_servers_list (network_id)
      org_endpoint "/network/#{network_id}/realServer"
      get
    end

    # Examples name = RealServer1, server_id = "415a7f70-1008-42a3-8375-5dcf52636cc5", in_service = true/false
    def real_server_create (network_id, name, server_id, in_service)
      org_endpoint "/network/#{network_id}/realServer"
      xml_params(tag: "NewRealServer", schema: "vip", name: name, server_id: server_id, in_service: in_service)
      post
    end


    def real_server_delete (network_id, rserver_id)
      org_endpoint "/network/#{network_id}/realServer/#{rserver_id}?delete"
      get
    end


    def real_server_modify (network_id, rserver_id, in_service)
      org_endpoint "/network/#{network_id}/realServer/#{rserver_id}"
      xml_params(in_service: in_service)
      post
    end

  # Probe section
    def probe_list (network_id)
      org_endpoint "/network/#{network_id}/probe"
      get
    end

    # Note this is for TCP, UDP & ICMP only additional xml fields need to be added to be complete
    # Examples name = Probe1, type = TCP, probeIntervalSeconds = "60", errorCountBeforeServerFail = "5" maxReplyWaitSeconds = "10"
    def probe_create
      org_endpoint "/network/#{network_id}/probe"
      xml_params(name: name, type: type, probeIntervalSeconds: probeIntervalSeconds, errorCountBeforeServerFail: errorCountBeforeServerFail, successCountBeforeServerEnable: successCountBeforeServerEnable, failedProbeIntervalSeconds: failedProbeIntervalSeconds, maxReplyWaitSeconds: maxReplyWaitSeconds)
      post
    end


    def probe_delete (network_id, probe_id)
      org_endpoint "/network/#{network_id}/probe/{probe_id}?delete"
      get
    end


  # Server Farm Section
    def server_farm_list (network_id)
      org_endpoint "/network/#{network_id}/serverFarm"
      get
    end

    def server_farm_details (network_id, server_farm_id)
      org_endpoint "/network/#{network_id}/serverFarm/#{server_farm_id}"
      get
    end

    def server_farm_create (network_id, name, real_server_id, port, predictor)
      if ["ROUND_ROBIN", "LEAST_CONNECTIONS"].include? predictor
        org_endpoint "/network/#{network_id}/serverFarm"
        xml_params(schema: "vip", tag: "NewServerFarm", name: name, predictor: predictor, real_server: {id: real_server_id, port: port})
        post
      else
        raise "Unknown predictor: #{predictor}"
      end
    end

    def server_farm_delete (network_id, server_farm_id)
      org_endpoint "/network/#{network_id}/serverFarm/#{server_farm_id}?delete"
      get
    end

    # Examples realServerId = "RealServer1", realSeverPort = "80"
    def real_server_to_server_farm (network_id, server_farm_id, real_server_id, real_server_port)
      org_endpoint "/network/#{network_id}/serverFarm/#{server_farm_id}/addRealServer"
      simple_params(real_server_id: real_server_id, real_server_port: real_server_port)
      post_simple
    end

    # Examples realServerId = "RealServer1", realSeverPort = "80"
    def real_server_from_server_farm (network_id, server_farm_id, real_server_id, real_server_port)
      org_endpoint "/network/#{network_id}/serverFarm/#{server_farm_id}/removeRealServer"
      simple_params(real_server_id: real_server_id, real_server_port: real_server_port)
      post_simple
    end


    # Examples probe_id = TCP1
    def probe_to_server_farm (network_id, server_farm_id, probe_id)
      org_endpoint "/network/#{network_id}/serverFarm/#{server_farm_id}/addProbe"
      xml_params(probe_id: probe_id)
      post
    end

    # Examples probe_id = TCP1
    def probe_from_server_farm (network_id, server_farm_id, probe_id)
      org_endpoint "/network/#{network_id}/serverFarm/#{server_farm_id}/removeProbe"
      xml_params(probe_id: probe_id)
      post
    end

    # Examples predictor= LEAST_CONNECTIONS | ROUND_ROBIN
    def server_farm_predictor(network_id, server_farm_id, predictor)
      org_endpoint "/network/#{network_id}/serverFarm/#{server_farm_id}"
      xml_params(predictor: predictor)
      post
    end

    def vip_list(network_id)
      org_endpoint "/network/#{network_id}/vip"
      get
    end

    def vip_create(network_id, name, port, protocol, server_farm_id)
      org_endpoint "/network/#{network_id}/vip"
      xml_params(schema: "vip", tag: "NewVip", name: name, port: port, protocol: protocol, vip_target_type: "SERVER_FARM", vip_target_id: server_farm_id, reply_to_icmp: true, in_service: true)
      post
    end

  end
end
