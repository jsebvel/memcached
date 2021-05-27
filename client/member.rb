class Member
    attr_reader :username, :socket, :values

    def initialize(username, socket)
        @username = username
        @socket = socket
        @values = {}
    end

    def welcome_from(members)
        socket.print "Welcome #{username}, Please enter commands here.\n >"
    end

    def prompt
        socket.print("\n>")
    end

    def newline_prompt
        socket.print(">")
    end

    def listen
        socket.readline.chomp
    end

    def disconnect
        socket.close
    end

    #Commands accepted

    def add(key, value)
        print(key)
        print(values)
        unless values.has_key?(key)
            values[key] = value
            socket.puts("The value was store")
            print(values)
        else
            socket.puts("The key already exists maybe you want to update it")
        end
    end

    def get(key, value)
        print(values)
        values.has_key?(key) ? socket.puts("The value for #{key} is #{values[key]}") : socket.puts("There are not a value for key '#{key}'.")
    end

    def set(key, value)
        values[key]=value
        socket.puts("The value was set")
    end
end