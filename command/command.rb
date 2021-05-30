class Command
    attr_reader :command_name, :key, :flags, :exptime, :bytes, :no_reply, :can_get 

    def initialize
        @command_name = command_name, 
        @key = key, 
        @flags = flags, 
        @exptime = exptime, 
        @bytes = bytes, 
        @no_reply = no_reply
        @can_get = can_get
    end
end
