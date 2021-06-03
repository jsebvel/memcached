require_relative "../../client/member"
require_relative "../../command/command"
require 'socket'

describe "#member" do
    values = {}
    socket = TCPSocket.new("localhost", 2000)
    new_member = Member.new("jsebvel", socket)
    add_command = Command.new(socket, "add", "name", "sebvel", 0, 0, "y", true)
    add_command_extime = Command.new(socket, "add", "name", "sebvel", 2, 0, "y", true)
    add_bad_command =  Command.new(socket, nil, nil, "sebvel", 5, 0, "y", true)
    
    context 'test about member add command' do
        before do
            values = {}
        end

        after do
            values = {}
        end
    
        it 'Values should have length 1' do
            new_member.add(add_command, values)
            expect(values.length).to be 1
        end

        it "Values key should be 'name'" do
            new_member.add(add_command, values)
            expect(values[add_command.key].key).to eq("name") 
        end

        it "Can get should be false after 2 seconds" do
            new_member.add(add_command_extime, values)
            expect(values[add_command_extime.key].can_get).to be true 
            sleep(add_command_extime.exptime)
            expect(values[add_command_extime.key].can_get).to be false 
        end

        it "Values at key position should not change" do
            add_command_try = Command.new(socket, "add", "name", "jsebvel", 0, 0, "y", true)
            new_member.add(add_command, values)
            new_member.add(add_command_try, values)
            expect(values[add_command.key].data).to eq("sebvel") 
        end
        
        it 'Values should have length 2' do
            add_command_try = Command.new(socket, "add", "lastname", "velasquez", 0, 0, "y", true)
            new_member.add(add_command, values)
            new_member.add(add_command_try, values)
            expect(values.length).to be 2
        end
    end

    context 'test about set command' do
        set_command = Command.new(socket, "set", "name", "sebastian", 0, 0, "y", true)
        new_member.add(add_command, values)
        it "Values on name key position should have value = 'sebastian" do
            new_member.set(set_command, values)
            expect(values[set_command.key].data).to eq("sebastian")
        end

        it "exptime for values[name] should be 10" do
            set_command = Command.new(socket, "set", "name", "sebastian", 10, 0, "y", true)
            new_member.set(set_command, values)
            expect(values[set_command.key].exptime).to be 10
        end

        it "can_get for values[name] should be false after 3 seconds" do
            set_command = Command.new(socket, "set", "name", "sebastian", 3, 0, "y", true)
            new_member.set(set_command, values)
            sleep(set_command.exptime)
            expect(values[set_command.key].can_get).to be false
        end

        it "can_get for values[name] should be true" do
            set_command = Command.new(socket, "set", "name", "sebastian", 0, 0, "y", false)
            new_member.set(set_command, values)
            sleep(set_command.exptime)
            expect(values[set_command.key].can_get).to be true
        end
    end
end