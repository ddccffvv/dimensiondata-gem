
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
