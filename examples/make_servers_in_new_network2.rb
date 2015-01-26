


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

options = {}

OptionParser.new do |opts|
	opts.banner = "Usage: example.rb [options]"

	opts.on("-n", "--number NUMBER", "Number of hosts") do |n|
		options[:number] = n.to_i
	end
	opts.on("-a", "--network_name name", "Name of the network to be created") do |n|
		options[:name] = n
	end
	opts.on_tail("-h", "--help", "Show this message") do
		puts opts
		exit
	end
end.parse!

if not options[:number]
	puts "Please specify the number of machines to create with -n"
	puts "For help, use -h"
	exit
end
if not options[:name]
	puts "Please specify the network name with -a"
	puts "For help, use -h"
	exit
end

c = DDcloud::Client.new @credentials[:url], @credentials[:org_id], @credentials[:user], @credentials[:pass]

c.network.create options[:name], "Automatically generated network"

network_id = c.network.show_by_name(options[:name])[:id]
image_id = "d4ed6d40-e2f0-11e2-84e5-180373fb68df" #default image id


before = c.server.list(network_id: network_id)
c.server.create "jumphost", "Automatically generated server", network_id, image_id
(1...options[:number]).each do |n|
	c.server.create "autoserver-#{n+1}", "Automatically generated server", network_id, image_id
end
(1...options[:number]).each do |n|
	block_until_server_normal c, "autoserver-#{n+1}"
	log "autoserver-#{n+1} started"
end
after = c.server.list(network_id: network_id)
created_servers = diff_id_hashes(before, after)
log "Created: #{created_servers.to_s}"

#create acl rule
c.network.aclrule_create(network_id, "allow ssh", 112, true, "TCP", 22, true)

#nat the servers so we can make our changes
server = created_servers[0]
details = after.select { |a| a["id"] == server }
details = details[0]
log details.to_s
c.network.natrule_create(network_id, details[:name], details[:private_ip])
