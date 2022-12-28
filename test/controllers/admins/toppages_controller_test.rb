require "test_helper"

class Admins::ToppagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admins_toppages_index_url
    assert_response :success
  end
end
