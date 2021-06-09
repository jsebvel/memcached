require 'socket'
require_relative '../client/member'
require_relative '../client/members'

class MainServer
    attr_writer :port, :server, :members
    
    def initialize
        @port = 2000
        @server = TCPServer.new(@port)
        @members = Members.new()
    end

    def init_server
        puts("Server start at port #{@port}")
        while true
            connection = @server.accept
            Thread.new(connection) do |socket|
                member = @members.register(socket)
                begin
                    @members.start_listening_to(member)
                rescue EOFError
                    @members.disconnect(member)
                end
            end
        end
    end 
end