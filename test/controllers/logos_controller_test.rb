require "test_helper"

class LogosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get logos_index_url
    assert_response :success
  end
end
