require 'test_helper'

class BranchTest < ActiveSupport::TestCase
  test "get the latest messages" do
      chat = channels(:chat)
      message_groups = chat.get_page_in_groups
      assert_equal 1, message_groups.size
      group = message_groups.first
      assert_equal 3, group.messages.size
  end

  test "add a new message to root" do
      axis = users(:axis)

      chat = channels(:chat)

      msg = Message.new
      msg.content = "Wow! I just saw an elephant!"
      msg.poster = axis.alias

      chat.messages << msg
      assert msg.save

      # check it
      assert_equal 4, msg.channel.messages.size

      message_groups = chat.get_page_in_groups
      assert_equal 1, message_groups.size
      group = message_groups.first
      assert_equal 4, group.messages.size
  end

  test "someone else make a new branch" do
      micah = users(:micah)
      chat = channels(:chat)
      pizza_message = messages(:pizza)

      twig = pizza_message.branch_message

      twig.content = "I love pizza!"
      twig.poster = micah.alias

      chat.messages << twig
      assert twig.save

      #check the new branch
      assert_equal 4, chat.messages.size
      
      message_groups = chat.get_page_in_groups(twig.branch_id)
      #p "Groups:"
      #p message_groups
      assert_equal 2, message_groups.size
      first_group = message_groups.first
      second_group = message_groups.last
      assert_equal 2, first_group.messages.size
      assert_equal 1, second_group.messages.size

      #check the old branch
      message_groups = chat.get_page_in_groups
      assert_equal 1, message_groups.size
      first_group = message_groups.first
      assert_equal 3, first_group.messages.size
  end
end
