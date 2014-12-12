


require "ddcloud"
require "pp"
require "optparse"

require "./credentials.rb"
require "./util.rb"


c = DDcloud::Client.new @credentials[:url], @credentials[:org_id], @credentials[:user], @credentials[:pass]

pp c.network.list
