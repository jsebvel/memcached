require_relative "../../client/member"
require_relative "../../command/command"
require_relative "../../command_function/command_function"
require 'socket'

describe "#command" do
    values = {}
    socket = TCPSocket.new("localhost", 2000)
    new_member = Member.new("jsebvel", socket)
    add_command = Command.new(socket, "add", "name", "sebvel", 0, 0, "y", true)
    add_command_extime = Command.new(socket, "add", "name", "sebvel", 2, 0, "y", true)
    add_bad_command =  Command.new(socket, nil, nil, "sebvel", 5, 0, "y", true)
    command_function = CommandFunction.new()
    
    before do
        values = {}
        add_command = Command.new(socket, "add", "name", "sebvel", 0, 0, "y", true)
    end
    
    after do
        add_command = Command.new(socket, "add", "name", "sebvel", 0, 0, "y", true)
        values = {}
    end
    context 'test about member add command' do
        it 'Values should have length 1' do
            command_function.add(add_command, values)
            expect(values.length).to be 1
        end

        it "Values key should be 'name'" do
            command_function.add(add_command, values)
            expect(values[add_command.key].key).to eq("name") 
        end

        it "Can get should be false" do
            add_command_cannotget = Command.new(socket, "add", "name", "sebvel", -5, 0, "y", true)
            command_function.add(add_command_cannotget, values)
            expect(values[add_command_cannotget.key].can_get).to be false 
        end
        it "Can get should be false after 2 seconds" do
            command_function.add(add_command_extime, values)
            expect(values[add_command_extime.key].can_get).to be true 
            sleep(add_command_extime.exptime + 1)
            expect(values[add_command_extime.key].can_get).to be false 
        end

        it "Values at key position should not change" do
            add_command_try = Command.new(socket, "add", "name", "jsebvel", 0, 0, "y", true)
            command_function.add(add_command, values)
            command_function.add(add_command_try, values)
            expect(values[add_command.key].data).to eq("sebvel") 
        end
        
        it 'Values should have length 2' do
            add_command_try = Command.new(socket, "add", "lastname", "velasquez", 0, 0, "y", true)
            command_function.add(add_command, values)
            command_function.add(add_command_try, values)
            expect(values.length).to be 2
        end
    end

    context 'test about set command' do
        set_command = Command.new(socket, "set", "name", "sebastian", 0, 0, "y", true)
        command_function.add(add_command, values)
        it "Values on name key position should have value = 'sebastian" do
            command_function.set(set_command, values)
            expect(values[set_command.key].data).to eq("sebastian")
        end

        it "can_get for values[name] should be false after 3 seconds" do
            set_command = Command.new(socket, "set", "name", "sebastian", 3, 0, "y", true)
            command_function.set(set_command, values)
            sleep(set_command.exptime)
            expect(values[set_command.key].can_get).to be false
        end

        it "can_get for values[name] should be false" do
            set_command = Command.new(socket, "set", "name", "sebastian", -3, 0, "y", false)
            command_function.set(set_command, values)
            expect(values[set_command.key].can_get).to be false
        end

        it "Value can_get should be true after execute set command" do
            add_command_no_get = Command.new(socket, "add", "lastname", "velasquez", -2, 0, "y", false)
            set_command_can_get = Command.new(socket, "set", "name", "sebastian", 0, 0, "y", false)
            command_function.add(add_command_no_get, values)
            command_function.set(set_command_can_get, values)
            expect(values[set_command_can_get.key].can_get).to be true
        end
    end

    context "test about replace command" do

        it 'update the value por key name' do
            replace_command = Command.new(socket, "replace", "name", "andres", 0, 0, "y", false)
            command_function.add(add_command, values)
            command_function.replace(replace_command, values)
            expect(values[replace_command.key].data).to eq("andres")
        end
        
        it 'Value can get should be false after replace' do
            replace_command = Command.new(socket, "replace", "name", "andres", -5, 0, "y", false)
            command_function.add(add_command, values)
            expect(values[replace_command.key].can_get).to be true
            command_function.replace(replace_command, values)
            expect(values[replace_command.key].can_get).to be false
        end

        it "Can get should be false after 2 seconds" do
            replace_command = Command.new(socket, "replace", "name", "andres", 2, 0, "y", false)
            command_function.add(add_command, values)
            command_function.replace(replace_command, values)
            sleep replace_command.exptime
            expect(values[replace_command.key].can_get).to be true
        end

    end
  
    context 'Test about append and prepend command' do

        it "should append 'rivera' to name value " do
            append_command = Command.new(socket, "append", "name", "rivera", 0, 0, "y", false)
            command_function.add(add_command, values)
            command_function.append_prepend(append_command, values)
            expect(values[append_command.key].data).to eq("sebvel rivera")
        end
        it "should append 'johan' to name value " do
            prepend_command = Command.new(socket, "prepend", "name", "johan", 0, 0, "y", false)
            command_function.add(add_command, values)
            command_function.append_prepend(prepend_command, values)
            expect(values[prepend_command.key].data).to eq("johan sebvel")
        end
    end

    context "test about 'cas' command" do
        cas_command = Command.new(socket, "cas", "name", "johan", 0, 0, "y", false)
        
        it "sould update name with cas name 'johan" do
            command_function.add(add_command, values)
            command_function.cas(cas_command, values)
            expect(values[cas_command.key].data).to eql("johan")
        end
        
        it "should not update name with cas data 'johan' " do
            cas_socket = TCPSocket.new("localhost", 2000)
            command_function.add(add_command, values)
            cas_command = Command.new(cas_socket, "cas", "name", "julian", 0, 0, "y", false)
            command_function.cas(cas_command, values)
            expect(values[cas_command.key].data).not_to eql("julian")
        end
    end
end