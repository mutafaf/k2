require 'test_helper'

class ReturnFormsControllerTest < ActionController::TestCase
  setup do
    @return_form = return_forms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:return_forms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create return_form" do
    assert_difference('ReturnForm.count') do
      post :create, return_form: { action_detail: @return_form.action_detail, description: @return_form.description, item_number: @return_form.item_number, order_number: @return_form.order_number, reason: @return_form.reason, return_quantity: @return_form.return_quantity, serial_number: @return_form.serial_number }
    end

    assert_redirected_to return_form_path(assigns(:return_form))
  end

  test "should show return_form" do
    get :show, id: @return_form
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @return_form
    assert_response :success
  end

  test "should update return_form" do
    patch :update, id: @return_form, return_form: { action_detail: @return_form.action_detail, description: @return_form.description, item_number: @return_form.item_number, order_number: @return_form.order_number, reason: @return_form.reason, return_quantity: @return_form.return_quantity, serial_number: @return_form.serial_number }
    assert_redirected_to return_form_path(assigns(:return_form))
  end

  test "should destroy return_form" do
    assert_difference('ReturnForm.count', -1) do
      delete :destroy, id: @return_form
    end

    assert_redirected_to return_forms_path
  end
end
