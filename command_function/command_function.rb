class CommandFunction
    def add(new_command, values)
        is_adding = 
        unless values.has_key?(new_command.key)
            values[new_command.key] = new_command
            new_command.can_get = assign_can_get(new_command.exptime)
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    store_message(new_command.member_socket[0])
                end
            end
            if (new_command.exptime.to_i > 0 && new_command.can_get)
                verify_exp_time(new_command)
            end
        else
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    exists_message(new_command.member_socket[0])
                end
            end
        end
        newline_prompt(new_command.member_socket[0])
    end

    def get(new_command, values)
        resp = values[new_command.key]
        if (!resp.nil? && resp.can_get) 
            resp.member_socket[0].puts("The value for #{new_command.key} is #{resp.data}")
        else
            new_command.member_socket[0].puts("NOT_FOUND '#{new_command.key}'.")
        end
        newline_prompt(new_command.member_socket[0])
    end

    def set(new_command, values)
        values[new_command.key]=new_command
        if new_command.reply
            if new_command.reply.downcase == 'y' 
                store_message(new_command.member_socket[0])
            end
            values[new_command.key].can_get = assign_can_get(new_command.exptime)
            if (new_command.exptime.to_i > 0 && new_command.can_get)
                verify_exp_time(new_command)
            end
        end
        newline_prompt(new_command.member_socket[0])
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
                    store_message(new_command.member_socket[0])
                end
            end
            if (new_command.exptime.to_i > 0 && new_command.can_get)
                verify_exp_time(new_command)
            end
        else
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    not_found_message(new_command.member_socket[0])
                end
            end
        end
        newline_prompt(new_command.member_socket[0])
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
                    store_message(new_command.member_socket[0])
                end
            end
        else
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    not_found_message(new_command.member_socket[0])
                end
            end
        end 
        newline_prompt(new_command.member_socket[0])
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
                        store_message(new_command.member_socket[0])
                    end
                end
            else
                if new_command.reply
                    if new_command.reply.downcase == 'y' 
                       not_store(new_command.member_socket[0])
                    end
                end
            end
        else
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    not_found_message(new_command.member_socket[0])
                end
            end
        end 
        newline_prompt(new_command.member_socket[0])
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

    def help(new_command)
        new_command.member_socket[0].puts("
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
        newline_prompt(new_command.member_socket[0])
    end

    def newline_prompt(socket)
        socket.print("> ")
    end

    private
    def store_message(socket)
        socket.puts("STORED")
        return "STORE"
    end

    def not_store(socket)
        socket.puts("NOT_STORED")
    end

    def exists_message(socket)
        socket.puts('EXISTS')
    end

    def not_found_message(socket)
        socket.puts('NOT_FOUND')
    end
end