require 'socket'
require '../client/member'
require '../client/members'

chunk_size = 1024
server = TCPServer.new(2000)
members = Members.new

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


