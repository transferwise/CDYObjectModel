require 'socket'

class Server
  def initialize(docs_location)
    @docs_location = docs_location
  end

  def start
    server = TCPServer.new 12345

    loop do
      client = server.accept
      request_line = client.gets.split
      request = {
          :method => request_line[0],
          :uri => request_line[1],
          :protocol_vers => request_line[2]
      }

      puts request.inspect

      file_path = @docs_location + request[:uri] + '.json'
      puts "Load response from #{file_path}"

      if File.exist?(file_path)
        contents = IO.read(file_path)
        status = '200 OK'
      else
        contents = '<h1>404 Not Found</h1><p>:(</p>'
        status = '404 Not Found'
      end

      headers = [
          "HTTP/1.1 #{status}",
          'Content-Type: text/html',
          "Content-Length: #{contents.length}",
          "\r\n"
      ].join("\r\n")

      client.write headers
      client.puts contents
      client.close
    end
  end
end
