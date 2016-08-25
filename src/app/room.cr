module App

  class Room

    def initialize
      @sockets = [] of HTTP::WebSocket
    end

    def add(socket : HTTP::WebSocket)
      @sockets << socket
      p "connected",@sockets.size
    end

    def remove(socket : HTTP::WebSocket)
      @sockets.delete socket
    end

    def send_all(json : String)
      @sockets.each do |socket| 
        socket.send json
      end
    end

  end

end