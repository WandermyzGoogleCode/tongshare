require 'test_helper'

class ThuauthControllerTest < ActionController::TestCase
  test "should get auth_with_xls_and_get_name" do
    get :auth_with_xls_and_get_name
    assert_response :success
  end

end
