require 'test_helper'

class TareasControllerTest < ActionController::TestCase
  test "should get get_ganalytics" do
    get :get_ganalytics
    assert_response :success
  end

end
