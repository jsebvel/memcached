require_relative '../command/command'
class Members
    include Enumerable
    def initialize
        @members = []
        @values = {}
        @command
    end

    def each
        @members.each { |member| yield member}
    end

    def add(member)
        @members << member
    end

    def remove(member)
        @members.delete(member)
    end

    def register(socket)
        username = get_member_info(socket)
        member = Member.new(username, socket)
        member.welcome_from()
        add(member)
        member
    end

    def start_listening_to(member)
        loop do
            message = member.listen
            member_socket = member.socket
            command_name, key, data, exptime, bytes, reply = message.split(" ")
            @command = Command.new(member.socket, command_name, key, data, exptime, bytes, reply, true)
            @command.handle_command(@command, member, @values)
        end
    end

    def disconnect(member)
        member.disconnect
        remove(member)
    end

    private
    def get_member_info(socket)
        socket.print "Hello! please tell us your name \n> "
        username = socket.gets.chomp
    end  
end
