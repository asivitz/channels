require 'test_helper'

class BranchTest < ActiveSupport::TestCase
  test "get the latest messages" do
      master = branches(:master)
      message_groups = master.get_page
      assert_equal 1, message_groups.size
      group = message_groups.first
      assert_equal 3, group.messages.size
  end
end
