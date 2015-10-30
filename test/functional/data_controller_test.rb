require 'test_helper'

class DataControllerTest < ActionController::TestCase
  test "should get test" do
    get :test
    assert_response :success
  end

  test "should get load" do
    get :load
    assert_response :success
  end

end
