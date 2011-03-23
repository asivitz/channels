require 'test_helper'

class BranchTest < ActiveSupport::TestCase
  test "get the latest messages" do
      master = branches(:master)
      message_groups = master.get_page_in_groups
      assert_equal 1, message_groups.size
      group = message_groups.first
      assert_equal 3, group.messages.size
  end

  test "add a new message to master" do
      axis = users(:axis)
      master = branches(:master)

      msg = Message.new
      msg.content = "Wow! I just saw an elephant!"
      msg.poster = axis.alias

      master.messages << msg
      msg.channel = master.channel
      assert msg.save

      # check it
      assert_equal 4, msg.channel.messages.size

      message_groups = master.get_page_in_groups
      assert_equal 1, message_groups.size
      group = message_groups.first
      assert_equal 4, group.messages.size
  end

  test "someone else make a new branch" do
      micah = users(:micah)
      master = branches(:master)
      pizza_message = messages(:pizza)
      channel = master.channel

      twig = pizza_message.make_branch
      assert twig.save

      msg = Message.new
      msg.content = "I love pizza!"
      msg.poster = micah.alias

      twig.messages << msg
      msg.channel = channel
      assert msg.save

      #check the new branch
      assert_equal 2, channel.branches.size
      assert_equal 4, channel.messages.size
      
      message_groups = twig.get_page_in_groups
      assert_equal 2, message_groups.size
      first_group = message_groups.first
      second_group = message_groups.last
      assert_equal 2, first_group.messages.size
      assert_equal 1, second_group.messages.size

      #check the old branch
      message_groups = master.get_page_in_groups
      assert_equal 1, message_groups.size
      first_group = message_groups.first
      assert_equal 3, first_group.messages.size
  end
end
