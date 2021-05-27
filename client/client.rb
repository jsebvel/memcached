require 'socket'

Socket.tcp('localhost', 2000) do |c|
    puts('fffff')
    c.close
end