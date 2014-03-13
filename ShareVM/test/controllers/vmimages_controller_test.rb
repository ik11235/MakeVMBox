require 'test_helper'

class VmimagesControllerTest < ActionController::TestCase
  setup do
    @vmimage = vmimages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vmimages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vmimage" do
    assert_difference('Vmimage.count') do
      post :create, vmimage: { osname: @vmimage.osname, osversion: @vmimage.osversion }
    end

    assert_redirected_to vmimage_path(assigns(:vmimage))
  end

  test "should show vmimage" do
    get :show, id: @vmimage
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vmimage
    assert_response :success
  end

  test "should update vmimage" do
    patch :update, id: @vmimage, vmimage: { osname: @vmimage.osname, osversion: @vmimage.osversion }
    assert_redirected_to vmimage_path(assigns(:vmimage))
  end

  test "should destroy vmimage" do
    assert_difference('Vmimage.count', -1) do
      delete :destroy, id: @vmimage
    end

    assert_redirected_to vmimages_path
  end
end
