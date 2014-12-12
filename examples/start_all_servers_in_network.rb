


require "ddcloud"
require "pp"
require "optparse"

require "./credentials.rb"

options = {}

OptionParser.new do |opts|
	opts.banner = "Usage: example.rb [options]"

	opts.on("-n", "--network_name name", "Name of the network") do |n|
		options[:name] = n
	end
	opts.on_tail("-h", "--help", "Show this message") do
		puts opts
		exit
	end
end.parse!

if not options[:name]
	puts "Please specify the network name with -n"
	puts "For help, use -h"
	exit
end

c = DDcloud::Client.new @credentials[:url], @credentials[:org_id], @credentials[:user], @credentials[:pass]

network = c.network.show_by_name options[:name]

if not network
	puts "A network with this name does not exist"
	exit
end

network_id = network[:id]

servers = c.server.list(network_id: network_id)

servers.each do |server|
	pp "Starting #{server[:name]}"
	c.server.start(server[:id])
end
