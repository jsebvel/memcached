class Command
    attr_accessor :member_socket, :command_name, :key, :flags, :exptime, :bytes, :no_reply, :can_get

    def initialize(member_socket, command_name, key, flags, exptime, bytes, no_reply, can_get)
        @member_socket = member_socket,
        @command_name = command_name, 
        @key = key, 
        @flags = flags, 
        @exptime = exptime, 
        @bytes = bytes, 
        @no_reply = no_reply
        @can_get = can_get
    end

    def update_attribute(attrbutes)

    end
end
