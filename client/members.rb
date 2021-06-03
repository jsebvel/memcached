require '../command/command'
class Members
    include Enumerable
    def initialize
        @members = []
        @values = {}
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
            handleCommand(message.split(" "), member, @values)
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

    private
    def handleCommand(message, member, values)
        member_socket = member.socket
        command_name, key, data, exptime, bytes, reply = message
        new_command  = Command.new(member_socket, command_name, key, data, exptime, bytes, reply, true)
        if (command_name == 'help')
            member.help
        elsif (command_name == 'get')
            member.get(key, values)
        else
            unless ([command_name, key, data, exptime, bytes, reply].include?(nil)) 
                case command_name
                when "add"
                    member.add(new_command, values)
                when "set"
                    member.set(new_command, values)
                when "append", "prepend"
                    member.append_prepend(new_command, values)
                when "replace"
                    member.replace(new_command, values)
                when "cas"
                    member.cas(new_command, values)
                else
                    member.socket.puts("ERROR => We can't find the command '#{command_name}'. enter help to see the accepted commands")
                end
            else
                member.socket.puts("CLIENT_ERROR => Type 'help' to see commands and structure.")
            end
        end
    end
end
