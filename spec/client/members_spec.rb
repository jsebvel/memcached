require_relative "../../client/members"
require_relative "../../client/member"
require_relative "../../command/command"
require 'socket'

describe "#members" do
    socket = TCPSocket.new("localhost", 2000)
    new_member = Member.new("jsebvel", socket)
    new_members = Members.new()
    socket_1 = TCPSocket.new("localhost", 2000)
    sebvel_member = Member.new('sebvel', socket_1)
    
    before do
        new_members = Members.new()
        new_member = Member.new("jsebvel", socket)
    end
    
    context 'test about add member' do
        it 'add new member to members list' do
            new_members.add(new_member)
            expect(new_members.members.length).to be(1)
        end
        it 'add two members to members list' do
            new_members.add(new_member)
            new_members.add(sebvel_member)
            expect(new_members.members.length).to be(2)
        end
    end
    
    context 'test about remove command' do
        it "should delete all members from members list" do
            new_members.add(sebvel_member)
            new_members.add(new_member)
            expect(new_members.members.length).to be(2)
            new_members.remove(sebvel_member)
            new_members.remove(new_member)
            expect(new_members.members.length).to be(0)
       end
        it "should delete a member with username 'sebvel'" do
            new_members.add(sebvel_member)
            new_members.add(new_member)
            expect(new_members.members.length).to be(2)
            new_members.remove(sebvel_member)
            expect(new_members.members.length).to be(1)
            expect(new_members.members[0].username).not_to eq('sebvel')
       end
   end
    

end