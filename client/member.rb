class Member
    attr_reader :username, :socket #:values

    def initialize(username, socket)
        @username = username
        @socket = socket
        #@values = {}
    end

    def welcome_from(members)
        socket.print "Welcome #{username}, Please enter commands in the next line.\nRemember command structure 'command name' 'key' 'data' 'except time' 'bytes' 'no reply'. \n"
        newline_prompt()
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
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    store_message()
                end
            end
            if (new_command.exptime.to_i > 0 && new_command.can_get)
                verify_exp_time(new_command)
            end
        else
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    exists_message()
                end
            end
        end
        newline_prompt()
    end

    def get(key, values)
        resp = values[key]
        if (!resp.nil? && resp.can_get)
            socket.puts("The value for #{key} is #{resp.data}")
        else
            socket.puts("NOT_FOUND '#{key}'.")
        end
        newline_prompt()
    end

    def set(new_command, values)
        values[new_command.key]=new_command
        if new_command.reply
            if new_command.reply.downcase == 'y' 
                store_message()
            end
            values[new_command.key].can_get = assign_can_get(new_command.exptime)
            if (new_command.exptime.to_i > 0 && new_command.can_get)
                verify_exp_time(new_command)
            end
        end
        newline_prompt()
    end

    def append_prepend(new_command, values)
        if (values.has_key? (new_command.key))
            values[new_command.key].can_get = assign_can_get(new_command.exptime)
            values[new_command.key].exptime = new_command.exptime
            if (new_command.command_name == 'append')
                values[new_command.key].data = "#{values[new_command.key].data} #{new_command.data}"
            elsif((new_command.command_name == 'prepend'))
                values[new_command.key].data = "#{new_command.data} #{values[new_command.key].data}"
            end
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    store_message()
                end
            end
            if (new_command.exptime.to_i > 0 && new_command.can_get)
                verify_exp_time(new_command)
            end
        else
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    not_found_message()
                end
            end
        end
        newline_prompt()
    end

    def replace(new_command, values)
        current_value = ''
        if(values.has_key?(new_command.key) && values[new_command.key].can_get )
            current_value = values[new_command.key]
            current_value.member_socket = new_command.member_socket
            current_value.data = new_command.data
            current_value.exptime = new_command.exptime
            current_value.can_get = assign_can_get(new_command.exptime)
            if (new_command.exptime.to_i > 0 && new_command.can_get)
                verify_exp_time(current_value)
            end
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    store_message()
                end
            end
        else
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    not_found_message()
                end
            end
        end 
        newline_prompt()
    end
    
    def cas(new_command, values)
        current_value_key = ''
        if(values.has_key?(new_command.key))
            if (values[new_command.key].member_socket[0] == new_command.member_socket[0])
                values[new_command.key].data = new_command.data 
                values[new_command.key].exptime = new_command.exptime 
                values[new_command.key].can_get = assign_can_get(new_command.exptime)
                if (new_command.exptime.to_i > 0 && new_command.can_get)
                    verify_exp_time(current_value)
                end
                if new_command.reply
                    if new_command.reply.downcase == 'y' 
                        store_message()
                    end
                end
            else
                if new_command.reply
                    if new_command.reply.downcase == 'y' 
                       not_store()
                    end
                end
            end
        else
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    not_found_message()
                end
            end
        end 
        newline_prompt()
    end

    def verify_exp_time(new_command)
        Thread.new(new_command.exptime) do
            while new_command.exptime.to_i > 0
                new_command.exptime = new_command.exptime.to_i - 1
                sleep(1)
            end
            new_command.can_get = false
        end
    end

    def assign_can_get(exptime)
        if exptime.to_i >= 0
            true
        else
            false
        end
    end
    
    def help()
        socket.puts("
        *Command structure is* > command_name key data exptime bytes, reply
        For example: add name user1 10 4 Y \n
        This is the list with know commands
        - Retrieval commands
        * get
        * gets \n
        - Storage commands
        * set
        * add
        * replace
        * append 
        * prepend
        * cas \n
        To close connection 'ctrl + c'
        ") 
        newline_prompt()
    end

    private
    def store_message()
        socket.puts("STORED")
    end

    def not_store()
        socket.puts("NOT_STORED")
    end

    def exists_message()
        socket.puts('EXISTS')
    end

    def not_found_message()
        socket.puts('NOT_FOUND')
    end
    
end