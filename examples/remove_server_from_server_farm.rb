
require "ddcloud"
require "pp"
require "optparse"

require "./credentials.rb"

def diff_id_hashes(h1, h2)
	a1 = h1.map { |e| e[:id] }
	a2 = h2.map { |e| e[:id] }
	a2 - a1
end

def block_until_server_normal(c, name)
	while true do
		if c.server.list(name: name)[:state] == "NORMAL"
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


log "server farm list"
pp c.vip.server_farm_list network_id

log "server farm details"
real_servers = c.vip.server_farm_details network_id, farm_id

pp real_servers
log "server farm real server details"
pp real_servers[:real_server]
if real_servers[:real_server].length > 1 && real_servers[:real_server].kind_of?(Array)
	host = real_servers[:real_server][0]

	list_real_servers = c.vip.real_servers_list network_id

	server_id = ""
	real_server_id = host[:id]
	pp real_server_id
	list_real_servers.each do |real_server|
		if real_server[:id] == real_server_id
			server_id = real_server[:server_id]
		end
	end

	pp server_id

	puts "----removing from the server farm----"
	pp c.vip.real_server_from_server_farm network_id, farm_id, real_server_id, 80
	puts "----shutting down server----"
	pp c.server.shutdown server_id
else
	log "no more servers to remove"
end


