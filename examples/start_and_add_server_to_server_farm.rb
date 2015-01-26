
require "ddcloud"
require "pp"
require "optparse"

require "./credentials.rb"

def diff_id_hashes(h1, h2)
	a1 = h1.map { |e| e[:id] }
	a2 = h2.map { |e| e[:id] }
	a2 - a1
end

def block_until_server_normal(c, name, network_id)
	while true do
		if c.server.list(name: name, network_id: network_id)[:state] == "NORMAL"
			break
		end
		sleep 1
	end
end

def log(string)
	time = DateTime.now.strftime("%H:%M")
	puts "#{time} -> #{string}"
end



c = DDcloud::Client.new @credentials[:url], @credentials[:org_id], @credentials[:user], @credentials[:pass]

network_id = "8a55ac56-2821-11e1-ada2-180373fb68df"
farm_id = "8b4eaa29-b290-4771-96f0-b9c79596bc44"


pp c.vip.server_farm_list network_id

real_servers = c.vip.server_farm_details network_id, farm_id

pp real_servers
pp real_servers[:real_server]
pp real_servers[:real_server].length
if real_servers[:real_server].length < 5 || (not real_servers[:real_server].kind_of?(Array))

	list_real_servers = c.vip.real_servers_list network_id

	server_id = ""
	real_server_id = ""
	pp real_server_id
	list_real_servers.each do |real_server|
		pp real_server
		real_server_id = real_server[:id]
		server =  c.server.show( real_server[:server_id])
		if server[:is_started] == "false"
			#start the server
			log "---- starting server #{server[:name]} ----"
			pp c.server.start server[:id]
			block_until_server_normal(c, server[:name], network_id)

			log "---- adding server to server farm ----"
			pp c.vip.real_server_to_server_farm network_id, farm_id, real_server_id, 80

			log("done")

			exit
		end
	end

else
	log "We don't have any more servers in our farm"
end


