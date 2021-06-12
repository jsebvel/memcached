require_relative "../../client/member"
require_relative "../../command/command"
require 'socket'

describe '#command' do
    socket = TCPSocket.new("localhost", 2000)
    socket_1 = TCPSocket.new('localhost', 2000)
    member_1 = Member.new("andres", socket_1)
    member = Member.new("jsebvel", socket)
    values = {}

    context "test about handle command from command class" do
        it ("should add new key to command values") do
            add_command = Command.new(socket, "add", "name", "sebvel", 0, 0, "y", true)
            add_command.handle_command(add_command, member, values)
            expect(values.length).to be(1)
        end

        it("should set name key with 'andres'") do
            set_command = Command.new(socket, "set", "name", "andres", 0, 0, "y", true)
            set_command.handle_command(set_command, member, values)
            expect(values["name"].data).to eq("andres")    
        end

        it("should append 'cardona' to key 'name'") do
            append_command = Command.new(socket, "append", "name", "cardona", 0, 0, "y", true)
            append_command.handle_command(append_command, member, values)
            expect(values["name"].data).to eq("andres cardona")
        end

        it("should prepend 'carlos' to key 'name'") do
            prepend_command = Command.new(socket, "prepend", "name", "carlos", 0, 0, "y", true)
            prepend_command.handle_command(prepend_command, member, values)
            expect(values["name"].data).to eq("carlos andres cardona")
        end
        
        it ("should update name with sebastian") do
            replace_command = Command.new(socket, "replace", "name", "sebastian", 0, 0, "y", true)
            replace_command.handle_command(replace_command, member, values)
            expect(values["name"].data).to eq("sebastian")
        end

        it ("should cas name with manuel") do
            cas_command = Command.new(socket, "replace", "name", "manuel", 0, 0, "y", true)
            cas_command.handle_command(cas_command, member, values)
            expect(values["name"].data).to eq("manuel")
        end
    end
end