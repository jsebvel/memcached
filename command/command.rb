class Command
    attr_accessor :member_socket, :command_name, :key, :data, :exptime, :bytes, :reply, :can_get

    def initialize(member_socket, command_name, key, data, exptime, bytes, reply, can_get)
        @member_socket = member_socket,
        @command_name = command_name, 
        @key = key, 
        @data = data, 
        @exptime = exptime, 
        @bytes = bytes, 
        @reply = reply
        @can_get = can_get
    end

    def update_attribute(attrbutes)

    end
end
