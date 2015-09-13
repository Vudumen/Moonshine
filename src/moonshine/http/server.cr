module Moonshine::Http
  class Server < HTTP::Server

  def initialize(@host, @port, &@handler : Request -> Response)
  end

  def initialize(@host, @port, handlers : Array(HTTP::Handler))
    @handler = HTTP::Server.build_middleware handlers
  end

  def initialize(@host, @port, @handler)
  end

  def listen
    server = TCPServer.new(@host, @port)
    until @wants_close
      spawn handle_client(server.accept)
    end
  end
    
  def listen_fork(workers = 8)
    server = TCPServer.new(@host, @port)
    workers.times do
      fork do
        loop { spawn handle_client(server.accept) }
      end
    end

    gets
  end

  end
end
