class Member
    attr_reader :username, :socket #:values

    def initialize(username, socket)
        @username = username
        @socket = socket
    end

    def welcome_from()
        socket.print "Welcome #{username}, Please enter commands in the next line.\nRemember command structure 'command name' 'key' 'data' 'except time' 'bytes' 'no reply'. \n> "
    end

    def listen
        socket.readline.chomp
    end

    def disconnect
        socket.close
    end
    
end