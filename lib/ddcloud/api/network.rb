module DDcloud::API
  class Network < Core
    def list
      org_endpoint '/network'
      get
    end

    def create(name, description="", datacenter=@client.datacenter)
      org_endpoint "/networkWithLocation"
      xml_params(schema: "network", tag: "NewNetworkWithLocation", name: name, description: description, location: datacenter)
      post
    end

    def list_with_location
      org_endpoint "/networkWithLocation"
      get
    end

    def list_in_location(location_id)
      org_endpoint "/networkWithLocation/#{location_id}"
      get
    end

    def show(network_id)
      list_with_location.find {|n| n.id == network_id}
    end

    def show_by_name(name)
     list_with_location.find {|n| n.name == name}
    end

    def natrule_list(network_id)
      org_endpoint "/network/#{network_id}/natrule"
      get
    end

    # name = "10.147.15.11", source_ip = "10.147.15.11"
    def natrule_create(network_id, name, source_ip)
      org_endpoint "/network/#{network_id}/natrule"
      xml_params(schema: "network", tag: "NatRule", name: name, source_ip: source_ip)
      post
    end

    def natrule_delete(network_id, natrule_id)
      org_endpoint "/network/#{network_id}/natrule/#{natrule_id}?delete"
      get
    end

    def aclrule_list(network_id)
      org_endpoint "/network/#{network_id}/aclrule"
      get
    end

    def aclrule_delete(network_id, aclrule_id)
      org_endpoint "/network/#{network_id}/aclrule/#{aclrule_id}?delete"
      get
    end

    def aclrule_create(network_id, name, position, inbound, protocol, port, allow)
      org_endpoint "/network/#{network_id}/aclrule"
      xml_params(schema: "network", tag: "AclRule", name: name, position: position, action: (allow ? "PERMIT" : "DENY"), protocol: protocol, source_ip_range: {}, destination_ip_range: {}, port_range: {type: "EQUAL_TO", port1: port}, type: (inbound ? "OUTSIDE_ACL" : "INSIDE_ACL"))
      post
    end
  end
end
