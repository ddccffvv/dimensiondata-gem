


require "ddcloud"
require "pp"
require "optparse"

require "./credentials.rb"
require "./util.rb"


c = DDcloud::Client.new DDcloud::Client::API_URL[:eu], @credentials[:org_id], @credentials[:user], @credentials[:pass]

puts DDcloud::Client::API_URL[:eu]

pp c.network.list
