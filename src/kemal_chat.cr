require "kemal"

SOCKS = [] of HTTP::WebSocket

Kemal.config.port = ENV["PORT"].to_i if ENV["PORT"]

get "/" do
  render "views/index.ecr"
end

ws "/chat" do |socket|
  SOCKS << socket
  socket.on_message do |message|
    SOCKS.each { |sock| sock.send message }
  end
  
  socket.on_close do
    SOCKS.delete socket
  end
end

Kemal.run