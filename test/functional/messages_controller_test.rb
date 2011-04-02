require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  test "should create message" do
    assert_difference('Message.count') do
      post :create, :message => { }
    end

    assert_redirected_to message_path(assigns(:message))
  end

  test "should destroy message" do
    assert_difference('Message.count', -1) do
      delete :destroy, :id => messages(:one).to_param
    end
  end
end
