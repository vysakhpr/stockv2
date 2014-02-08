require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get principal" do
    get :principal
    assert_response :success
  end

  test "should get office" do
    get :office
    assert_response :success
  end

  test "should get login" do
    get :login
    assert_response :success
  end

end
