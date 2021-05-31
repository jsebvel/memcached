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
        socket.print("> ")
    end

    def listen
        socket.readline.chomp
    end

    def disconnect
        socket.close
    end

    #Commands accepted

    def add(new_command, values)
        unless values.has_key?(new_command.key)
            values[new_command.key] = new_command
            new_command.can_get = assign_can_get(new_command.exptime)
            socket.puts("STORED -> The value was store")
            if (new_command.exptime.to_i > 0 && new_command.can_get)
                verify_exp_time(new_command)
            end
        else
            socket.puts("The key already exists maybe you want to update it")
        end
        newline_prompt()
    end

    def get(key, values)
        resp = values[key]
        if (!resp.nil? && resp.can_get)
            socket.puts("The value for #{key} is #{resp.flags}")
        else
            socket.puts("There are not a value for key '#{key}'.")
        end
        newline_prompt()
    end

    def set(new_comand, values)
        values[new_command.key]=new_command
        socket.puts("The value was set")
        newline_prompt()
    end

    def append(new_command)
        values[key] = "#{values[key]}, #{value}"
        socket.puts("The value was append to key #{key}.")
        newline_prompt()
    end

    def prepend(key, value)
        values[key] = "#{value}, #{values[key]}"
        socket.puts("The value was prepend.")
        newline_prompt()
    end 

    def replace(new_command, values)
        current_value = ''
        if(values.has_key?(new_command.key) && values[new_command.key].can_get )
            current_value = values[new_command.key]
            current_value.flags = new_command.flags
            current_value.exptime = new_command.exptime
            current_value.can_get = assign_can_get(new_command.exptime)
            if (new_command.exptime.to_i > 0 && new_command.can_get)
                verify_exp_time(current_value)
            end
            socket.puts("The value was updated with #{new_command.flags}")
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

    def verify_exp_time(new_command)
        Thread.new(new_command.exptime) do
            while new_command.exptime.to_i > 0
                print("In #{new_command.exptime}\n")
                new_command.exptime = new_command.exptime.to_i - 1
                print(new_command.can_get)
                sleep(1)
            end
            new_command.can_get = false
            print(new_command.can_get)
        end
    end

    def assign_can_get(exptime)
        print(exptime)
        if exptime.to_i >= 0
            true
        else
            false
        end
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