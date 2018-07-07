require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get all" do
    get reports_all_url
    assert_response :success
  end

end
