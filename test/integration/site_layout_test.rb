require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "layout links when not logged in" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get help_path
    assert_template 'static_pages/help'
    assert_select "title", full_title("Help")
    get users_path
    assert_redirected_to login_url
    get contact_path
    assert_template 'static_pages/contact'
    assert_select "title", full_title("Contact")
    get signup_path
    assert_template 'users/new'
    assert_select "title", full_title("Sign up")
  end

  test "header links when logged in" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path
    # assert_select "a[href=?]", show_user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get help_path
    assert_template 'static_pages/help'
    assert_select "title", full_title("Help")
    get users_path
    assert_template 'users/index'
    assert_select "title", full_title("All users")
    # get @user
    # assert_template 'users/show'
    # assert_select "title", full_title(@user.name)
    get edit_user_path(@user)
    assert_template 'users/edit'
    assert_select "title", full_title("Edit user")
    delete logout_path
    assert_redirected_to root_url
    get contact_path
    assert_template 'static_pages/contact'
    assert_select "title", full_title("Contact")
    get signup_path
    assert_template 'users/new'
    assert_select "title", full_title("Sign up")
  end
end