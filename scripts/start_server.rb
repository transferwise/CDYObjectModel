require 'server'

docs_location = ARGV[0]

server = Server.new(docs_location)
server.start