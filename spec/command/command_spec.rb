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
            result = add_command.handle_command(add_command, member, values)
            expect(values.length).to be(1)
            expect(result).to eq("STORE")
        end
        
        it ("should not add new entry to values") do
            add_command = Command.new(socket, "add", "name", "juan", 0, 0, "y", true)
            result = add_command.handle_command(add_command, member, values)
            expect(values.length).to be(1)
            expect(result).to eq("EXISTS")
        end
        
        it("should set name key with 'andres'") do
            set_command = Command.new(socket, "set", "name", "andres", 0, 0, "y", true)
            result = set_command.handle_command(set_command, member, values)
            expect(values["name"].data).to eq("andres")    
            expect(result).to eq("STORE")
        end
        
        it("should append 'cardona' to key 'name'") do
            append_command = Command.new(socket, "append", "name", "cardona", 0, 0, "y", true)
            result = append_command.handle_command(append_command, member, values)
            expect(values["name"].data).to eq("andres cardona")
            expect(result).to eq("STORE")
        end
        
        it("should prepend 'carlos' to key 'name'") do
            prepend_command = Command.new(socket, "prepend", "name", "carlos", 0, 0, "y", true)
            result = prepend_command.handle_command(prepend_command, member, values)
            expect(values["name"].data).to eq("carlos andres cardona")
            expect(result).to eq("STORE")
        end

        it("should not append to non existent key 'lastname'") do
            append_command = Command.new(socket, "append", "lastname", "cardona", 0, 0, "y", true)
            result = append_command.handle_command(append_command, member, values)
            expect(result).to eq("NOT_FOUND")
        end

        it("should not prepend non existent key 'lastname'") do
            prepend_command = Command.new(socket, "prepend", "lastname", "carlos", 0, 0, "y", true)
            result = prepend_command.handle_command(prepend_command, member, values)
            expect(result).to eq("NOT_FOUND")
        end
        
        it ("should update name with sebastian") do
            replace_command = Command.new(socket, "replace", "name", "sebastian", 0, 0, "y", true)
            result = replace_command.handle_command(replace_command, member, values)
            expect(values["name"].data).to eq("sebastian")
            expect(result).to eq("STORE")
        end

        it ("should not update non existent key lastname") do
            replace_command = Command.new(socket, "replace", "lastname", "velasquez", 0, 0, "y", true)
            result = replace_command.handle_command(replace_command, member, values)
            expect(values["name"].data).to eq("sebastian")
            expect(result).to eq("NOT_FOUND")
        end
        
        it ("should cas name with manuel") do
            cas_command = Command.new(socket, "cas", "name", "manuel", 0, 0, "y", true)
            result = cas_command.handle_command(cas_command, member, values)
            expect(values["name"].data).to eq("manuel")
            expect(result).to eq("STORE")
        end
        
        it ("should not cas name with carlos") do
            cas_command = Command.new(socket_1, "cas", "name", "carlos", 0, 0, "y", true)
            result = cas_command.handle_command(cas_command, member, values)
            expect(values["name"].data).to eq("manuel")
            expect(result).to eq("NOT_STORED")
        end
        
        it ("should not cas non existent key value") do
            cas_command = Command.new(socket_1, "cas", "value", "carlos", 0, 0, "y", true)
            result = cas_command.handle_command(cas_command, member, values)
            expect(values["name"].data).to eq("manuel")
            expect(result).to eq("NOT_FOUND")
        end

        it ("should get value for key  'name'") do
            get_command = Command.new(socket, "get", "name", nil, nil, nil, nil, nil)
            result = get_command.handle_command(get_command, member, values)
            expect(result).to eq("manuel")
        end

        it ("should can't get value for non existent key 'lastname'") do
            get_command = Command.new(socket, "get", "lastname", nil, nil, nil, nil, nil)
            result = get_command.handle_command(get_command, member, values)
            expect(result).to eq("NOT_FOUND")
        end
    end
end