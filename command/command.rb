require "./command_function/command_function"
class Command
    attr_accessor :member_socket, :command_name, :key, :data, :exptime, :bytes, :reply, :can_get, :command_function, :can_update

    def initialize(member_socket, command_name, key, data, exptime, bytes, reply, can_get)
        @member_socket = member_socket,
        @command_name = command_name, 
        @key = key, 
        @data = data, 
        @exptime = exptime, 
        @bytes = bytes, 
        @reply = reply
        @can_get = can_get
        @command_function = CommandFunction.new()
        @can_update
    end

    def handle_command(new_command, member, values) 
        if (new_command.command_name == 'help')
            command_function.help(new_command)
        elsif (new_command.command_name == 'get')
            command_function.get(new_command, values)
        else
            unless ([new_command.command_name, new_command.key, new_command.data, new_command.exptime, new_command.bytes, new_command.reply].include?(nil)) 
                case new_command.command_name
                when "add"
                    command_function.add(new_command, values)
                when "set"
                    command_function.set(new_command, values)
                when "append", "prepend"
                    command_function.append_prepend(new_command, values)
                when "replace"
                    command_function.replace(new_command, values)
                when "cas"
                    command_function.cas(new_command, values)
                else
                    member.socket.puts("ERROR => We can't find the command '#{command_name}'. enter help to see the accepted commands")
                end
            else
                member.socket.puts("CLIENT_ERROR => Type 'help' to see commands and structure.")
            end
        end
    end
end
