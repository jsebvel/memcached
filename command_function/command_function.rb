require "pry"
class CommandFunction
    attr_writer :result;

    def initialize
        @result =  ""
    end
    def add(new_command, values)
        #is_adding = 
        unless values.has_key?(new_command.key)
            new_command.can_update = true
            values[new_command.key] = new_command
            new_command.can_get = assign_can_get(new_command.exptime)
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    @result = store_message(new_command.member_socket[0])
                end
            end
            if (new_command.exptime.to_i > 0 && new_command.can_get)
                verify_exp_time(new_command)
            end
        else
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    @result = exists_message(new_command.member_socket[0])
                end
            end
        end
        newline_prompt(new_command.member_socket[0])
        @result
    end

    def get(new_command, values)
        resp = values[new_command.key]
        if (!resp.nil? && resp.can_get) 
            @result = resp.data
            resp.member_socket[0].puts(@result)
        else
            new_command.member_socket[0].puts("NOT_FOUND")
            @result = "NOT_FOUND"
        end
        newline_prompt(new_command.member_socket[0])
        @result
    end

    def set(new_command, values)
        exists = values[new_command.key]
        can_update = verify_can_modify(new_command, exists, values)
        if (can_update)
            new_command.can_update = false
            values[new_command.key]=new_command
            if new_command.reply
                @result  = store_message(new_command.member_socket[0])   
            end
            values[new_command.key].can_get = assign_can_get(new_command.exptime)
            if (new_command.exptime.to_i > 0 && new_command.can_get)
                verify_exp_time(new_command)
            end
        else
            @result = blocked_message(new_command.member_socket[0])
        end
        values[new_command.key].can_update = true
        newline_prompt(new_command.member_socket[0])
        @result
    end

    def append_prepend(new_command, values);
        if (values.has_key? (new_command.key))
            exists = values[new_command.key]
            can_update = verify_can_modify(new_command, exists, values)
            if (can_update)
                values[new_command.key].can_update = false
                values[new_command.key].exptime = new_command.exptime
                if (new_command.command_name == 'append')
                    values[new_command.key].data = "#{values[new_command.key].data} #{new_command.data}"
                elsif((new_command.command_name == 'prepend'))
                    values[new_command.key].data = "#{new_command.data} #{values[new_command.key].data}"
                end
                if new_command.reply
                    if new_command.reply.downcase == 'y' 
                        @result = store_message(new_command.member_socket[0])
                    end
                end
                if (new_command.exptime.to_i > 0 && new_command.can_get)
                    verify_exp_time(new_command)
                end
            else
                @result = blocked_message(new_command.member_socket[0])
            end
            values[new_command.key].can_update = true
        else
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    @result = not_found_message(new_command.member_socket[0])
                end
            end
        end
        newline_prompt(new_command.member_socket[0])
        @result
    end

    def replace(new_command, values)
        current_value = ''
        if(values.has_key?(new_command.key) && values[new_command.key].can_get )
            current_value = values[new_command.key]
            can_update = verify_can_modify(new_command, current_value, values)
            if (can_update)
                values[new_command.key].can_update = false
                current_value.member_socket = new_command.member_socket
                current_value.data = new_command.data
                current_value.exptime = new_command.exptime
                current_value.can_get = assign_can_get(new_command.exptime)
                if (new_command.exptime.to_i > 0 && new_command.can_get)
                    verify_exp_time(current_value)
                end
                if new_command.reply
                    if new_command.reply.downcase == 'y' 
                        @result = store_message(new_command.member_socket[0])
                    end
                end
            else
                @result = blocked_message(new_command.member_socket[0])
            end
            values[new_command.key].can_update = true
        else
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    @result = not_found_message(new_command.member_socket[0])
                end
            end
        end 
        newline_prompt(new_command.member_socket[0])
        @result
    end
    
    def cas(new_command, values)
        current_value_key = ''
        if(values.has_key?(new_command.key))
            current_data = values[new_command.key]
            can_update = verify_can_modify(new_command, current_data, values)
            if (can_update) 
                values[new_command.key].can_update = false
                if (values[new_command.key].member_socket[0] == new_command.member_socket[0])
                    values[new_command.key].data = new_command.data 
                    values[new_command.key].exptime = new_command.exptime 
                    values[new_command.key].can_get = assign_can_get(new_command.exptime)
                    if (new_command.exptime.to_i > 0 && new_command.can_get)
                        verify_exp_time(current_value)
                    end
                    if new_command.reply
                        if new_command.reply.downcase == 'y' 
                            @result = store_message(new_command.member_socket[0])
                        end
                    end
                else
                    if new_command.reply
                        if new_command.reply.downcase == 'y' 
                            @result = not_store(new_command.member_socket[0])
                        end
                    end
                end
            else
                @result = blocked_message(new_command.member_socket[0])
            end 
            values[new_command.key].can_update = true
        else
            if new_command.reply
                if new_command.reply.downcase == 'y' 
                    @result = not_found_message(new_command.member_socket[0])
                end
            end
        end 
        newline_prompt(new_command.member_socket[0])
        @result
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
    def verify_can_modify(new_commad, exists, values)
        result = ""
        if (new_commad.command_name == "set")
            result = verify_to_set(new_commad, exists, values)
        else
            result = values[new_commad.key].can_update == true ? true: false
        end
        result
    end

    def verify_to_set(new_command, exists, values)
        if (exists != nil && exists.can_update == true)
            result = true
        end

        if (exists != nil && exists.can_update == false)
            result = false
        end

        if (exists == nil) 
            result = true
        end
        result
    end

    def store_message(socket)
        socket.puts("STORED")
        return "STORE"
    end
    
    def not_store(socket)
        socket.puts("NOT_STORED")
        return "NOT_STORED"
    end

    def exists_message(socket)
        socket.puts('EXISTS')
        return "EXISTS"
        
    end

    def not_found_message(socket)
        socket.puts('NOT_FOUND')
        "NOT_FOUND"
    end

    def blocked_message(socket)
        socket.puts("UNAVAILABLE")
        return "UNAVAILABLE"
    end
end