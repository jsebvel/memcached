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

    # def broadcast(message, sender)
    #     sender.prompt
    #     receivers = @members - [sender]
    #     receivers.each do |receiver|
    #         receiver.socket.print("\n> #{sender.username}: #{message}")
    #         receiver.newline_prompt
    #     end
    # end

    def register(socket)
        username = get_member_info(socket)
        member = Member.new(username, socket)
        member.welcome_from(self)
        add(member)
        #broadcast("[joined]", member)
        member
    end

    def start_listening_to(member)
        loop do
            message = member.listen
            handleCommand(message.split(" "), member, @values)
            #broadcast(message, member)
        end
    end

    def disconnect(member)
        #broadcast("[left]", member.username)
        member.disconnect
        remove(member)
    end

    private
    def get_member_info(socket)
        socket.print "What's your name? \n>"
        username = socket.gets.chomp
    end

    private
    def handleCommand(message, member, values)
        member_socket = member.socket
        command_name, key, flags, exptime, bytes, no_reply = message
        #can_get = assign_can_get(exptime)
        new_command  = Command.new(member_socket, command_name, key, flags, exptime, bytes, no_reply, true)
        print("new command-#{new_command.exptime}")
        if (exptime.to_i > 0)
            verify_exp_time(new_command)
        end

        case command
        when "add"
            member.add(new_command)
        when "get"
            print("Enter in get \n")
            member.get(key, value, values)
        when "set"
            print("Enter set\n")
            member.set(key, value, values)
        when "append"
            print("Enter print\n")
            member.append(key, value)
        when "prepend"
            print("Enter prepend \n")
            member.prepend(key, value)
        when "replace"
            print("Enter replace \n")
            member.replace(key, value)
        when "cas"
            print("Enter cas \n")
            member.cas(key, value, values)
        when "help"
            member.help()
        else
            member.socket.puts("ERROR We can't find the command '#{command}'. enter help to see the accepted commands")
            member.socket.puts(">")
        end    
    end

    def assign_can_get(exp_time)
        #print("extime #{exp_time}")
        case exp_time
        when exp_time.to_i == 0 ||  exp_time.to_i > 0
            true
        else
            true
        end
    end

    def verify_exp_time(new_command)
        print("#{new_command}\n")
        print("pre")
        Thread.new(new_command.exptime) do
            while new_command.exptime.to_i > 0
                print("In #{new_command.exptime}\n")
                new_command.exptime = new_command.exptime.to_i - 1
                print(new_command.can_get)
                sleep(1)
            end
            #print("Out #{new_command.exptime}")
            new_command.can_get = false
            print(new_command.can_get)
        end
    end

end
