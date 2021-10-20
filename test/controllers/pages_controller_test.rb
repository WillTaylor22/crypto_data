require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get table" do
    get pages_table_url
    assert_response :success
  end

  test "should get local" do
    get pages_local_url
    assert_response :success
  end

  test "should get compare" do
    get pages_compare_url
    assert_response :success
  end
end
