require "test_helper"

class Api::Spec::ExcelControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get api_spec_excel_show_url
    assert_response :success
  end
end
