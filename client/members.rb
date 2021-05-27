class Members
    include Enumerable
    def initialize
        @members = []
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

    def broadcast(message, sender)
        sender.prompt
        receivers = @members - [sender]
        receivers.each do |receiver|
            receiver.socket.print("\n> #{sender.username}: #{message}")
            receiver.newline_prompt
        end
    end

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
            handleCommand(message.split(" "), member)
            broadcast(message, member)
        end
    end

    def disconnect(member)
        broadcast("[left]", member.username)
        member.disconnect
        remove(member)
    end

    private
    def get_member_info(socket)
        socket.print "What's your name? \n"
        username = socket.gets.chomp
    end

    private
    def handleCommand(message, member)
        command, key, value = message
        print("#{command}")
        case command
        when "add"
            member.add(key, value)
        when "get"
            print("Enter in get")
            member.get(key, value)
        when "set"
            print("Enter set")
            member.set(key, value)
        else
            member.socket.puts("We can't find the command '#{command}'.")
        end    
    end

end
