require 'socket'
require '../client/member'
require '../client/members'

chunk_size = 1024
port = 2000
server = TCPServer.new(port)
members = Members.new
puts("Server start at port #{port}")
while true
    connection = server.accept
    Thread.new(connection) do |socket|
        member = members.register(socket)
        begin
            members.start_listening_to(member)
        rescue EOFError
            members.disconnect(member)
        end
    end
end


