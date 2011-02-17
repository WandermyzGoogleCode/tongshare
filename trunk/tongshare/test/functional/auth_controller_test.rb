require 'test_helper'

class AuthControllerTest < ActionController::TestCase
  test "should get confirm" do
    get :confirm
    assert_response :success
  end

end
