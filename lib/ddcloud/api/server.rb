module DDcloud::API
  class Server < Core

    # id
    # location
    # networkId
    # sourceImageId
    # deployed boolean
    # name -- Matched against names of servers
    # created.MIN=20120901T00:00:00Z
    # created.MAX=20120901T00:00:00Z
    # state
    #   "NORMAL",
    #   "PENDING_ADD",
    #   "PENDING_CHANGE",
    #   "PENDING_DELETE",
    #   "FAILED_ADD",
    #   "FAILED_DELETE",
    #   "PENDING_CLEAN" and
    #   "REQUIRES_SUPPORT".
    # order_by: started, operatingSystemId, state and all other
    def list(options = {})
      org_endpoint "/serverWithState"
      query_params options
      get
    end

    def list_deployed_with_disks(network_id, options = {})
      org_endpoint "/network/#{network_id}/server/deployedWithDisks"
      query_params options
      get
    end

    def show(server_id, options = {})
      options[:id] = server_id
      single(list(options))
    end

    def show_by_name(name, options = {})
      options[:name] = name
      single(list(options))
    end

    def show_by_ip(ip, options = {})
      options[:private_ip] = ip
      single(list(options))
    end

    def show_with_disks(network_id, server_id, options = {})
      list_deployed_with_disks(network_id, options).find {|s| s.id == server_id}
    end

    def create(name, description, network_id, image_id, administrator_password=@client.default_password)
      org_endpoint "/server"
      xml_params(
        tag: "Server",
        schema: "server",
        name: name,
        description: description,
        vlan_resource_path: "/oec/#{org_id}/network/#{network_id}",
        image_resource_path: "/oec/base/image/#{image_id}",
        is_started: 'true',
        administrator_password: administrator_password
      )
      post
    end

    def delete(server_id)
      org_endpoint "/server/#{server_id}?delete"
      get
    end

    # memory in MB, ust be multiple of 1024
    def modify(server_id, name = nil, description = nil, cpu_count = nil, memory = nil)
      query_params(
        name: name,
        description: description,
        cpu_count: cpu_count,
        memory: memory
      )
      org_endpoint "/server/#{server_id}"
      post
    end

    def start(server_id)
      org_endpoint "/server/#{server_id}?start"
      get
    end

    def shutdown(server_id)
      org_endpoint "/server/#{server_id}?shutdown"
      get
    end

    def poweroff(server_id)
      org_endpoint "/server/#{server_id}?poweroff"
      get
    end

    def reboot(server_id)
      org_endpoint "/server/#{server_id}?reboot"
      get
    end

    def reset(server_id)
      org_endpoint "/server/#{server_id}?reset"
      get
    end

    # amount is # of GBs
    def add_storage(server_id, amount)
      org_endpoint "/server/#{server_id}?addLocalStorage"
      query_params(amount: amount)
      get
    end

    def remove_storage(server_id, disk_id)
      org_endpoint "/server/#{server_id}/disk/#{disk_id}?delete"
      get
    end

  end
end

#### ServersWithState
# <ServersWithState
# xmlns="http://oec.api.opsource.net/schemas/server"
# totalCount="320"
# pageCount="250"
# pageNumber="1"
# pageSize="250">
# <!--Zero or more repetitions:-->
# <serverWithState id="c325fe04-7711-4968-962e-c88784eb2" location="NA1">
# <name>Production LAMP Server</name>
# <!--Optional:-->
# <description>Main web application server.</description>
# <operatingSystem id="REDHAT564" displayName="REDHAT5/64" type="UNIX"/>
# <cpuCount>2</cpuCount>
# <memoryMb>4096</memoryMb>
# <!-- one or more repetitions:-->
# <disk id="x445fe05-7113-4988-9d2e-cbjt78eb2" scsiId="0" sizeGb="50"
# speed="STANDARD" state="NORMAL"/>
# <disk id="ef49974c-87d0-400f-aa32-ee43559fdb1b" scsiId="1" sizeGb="150"
# speed="STANDARD" state="NORMAL"/>
# <!--Zero or more repetitions:-->
# <softwareLabel>REDHAT5ES64</softwareLabel>
# <!--Optional:-->
# <sourceImageId>5a18d6f0-eaca-11e1-8340-d93da27669ab</sourceImageId>
# <networkId>xb632974c-87d0-400faa32-hb43559flk765</networkId>
# © 2013 Dimension Data Cloud Solutions
# 69
# <machineName>10-157-3-125</machineName>
# <privateIp>10.157.3.125</privateIp>
# <!--Optional:-->
# <publicIp>206.80.63.208</publicIp>
# <created>2012-07-02T10:43:31.000Z</created>
# <isStarted>false</isStarted>
# <isDeployed>true</isDeployed>
# <state>PENDING_CHANGE</state>
# <!--Zero or more repetitions:-->
# <machineStatus name="vmwareToolsRunningStatus">
# <value>RUNNING</value>
# </machineStatus>
# <!--Optional:-->
# <status>
# <action>START_SERVER</action>
# <requestTime>2012-09-26T08:36:28</requestTime>
# <userName>btaylor</userName>
# <!--Optional:-->
# <numberOfSteps>3</numberOfSteps>
# <!--Optional:-->
# <updateTime>2012-09-26T08:37:28</updateTime>
# <!--Optional:-->
# <step>
# <name>Waiting for operation</name>
# <number>3</number>
# <!--Optional:-->
# <percentComplete>3</percentComplete>
# </step>
# <!--Optional: (present only if the last operation failed and left
# the server in a locked state) -->
# <failureReason>Message Value</failureReason>
# </status>
# </serverWithState>
# </ServersWithState>
