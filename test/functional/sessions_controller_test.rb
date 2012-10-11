require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get login," do
    get :login,
    session[:id] = 1
    assert_response :success
  end

  test "should get home," do
    get :home,
    session[:id] = 1
    assert_response :success
  end

  test "should get profile," do
    get :profile,
    session[:id] = 1
    assert_response :success
  end

  test "should get setting" do
    get :setting
    session[:id] = 1
    assert_response :success
  end

end
