require "test_helper"

class Admin::LeaveRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_leave_requests_index_url
    assert_response :success
  end

  test "should get update" do
    get admin_leave_requests_update_url
    assert_response :success
  end
end
