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
      p "disconnected",@sockets.size
    end

    def send_all(json : String)
      @sockets.each do |socket| 
        socket.send json if socket
      end
    end

  end

end