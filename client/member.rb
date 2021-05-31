class Member
    attr_reader :username, :socket #:values

    def initialize(username, socket)
        @username = username
        @socket = socket
        #@values = {}
    end

    def welcome_from(members)
        socket.print "Welcome #{username}, Please enter commands here.\n"
        newline_prompt()
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

    def add(key, value, values)
        unless values.has_key?(key)
            values[key] = {value => socket}
            socket.puts("The value was store")
        else
            socket.puts("The key already exists maybe you want to update it")
        end
        newline_prompt()
    end

    def get(key, value, values)
        values.has_key?(key) ? socket.puts("The value for #{key} is #{values[key].keys[0]}") : socket.puts("There are not a value for key '#{key}'.")
        newline_prompt()
    end

    def set(key, value, values)
        values[key]=value
        socket.puts("The value was set")
        newline_prompt()
    end

    def append(key, value)
        values[key] = "#{values[key]}, #{value}"
        socket.puts("The value was append to key #{key}.")
        newline_prompt()
    end

    def prepend(key, value)
        values[key] = "#{value}, #{values[key]}"
        socket.puts("The value was prepend.")
        newline_prompt()
    end 

    def replace(key, value)
        current_value_key = ''
        if(values.has_key?(key))
            current_value_key = values[key].keys[0]
            values[key] = {value => socket}
            socket.puts("The value was updated with #{value}")
        else
            socket.puts("The key does not exist.")
        end 
        newline_prompt()
    end
    
    def cas(key, value, values)
        current_value_key = ''
        if(values.has_key?(key))
            current_value_key = values[key].keys[0]
            if (values[key][current_value_key] == socket)
                values[key] = {value => socket}
                socket.puts("The value was updated with #{value}")
            else
                socket.puts("The value can't cas by you beacouse other user updated the value for #{key}.")
            end
        else
            socket.puts("The key does not exist.")
        end 
        newline_prompt()
    end
    
    def help()
        socket.puts("This is the list with know commands
        * set \n
        * add \n
        * replace \n
        * append \n
        * prepend \n
        * cas \n
        * get \n
        * gets") 
        newline_prompt()
    end
end