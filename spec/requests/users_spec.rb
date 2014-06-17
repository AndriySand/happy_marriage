require 'spec_helper'

describe "Users" do

  before(:each) { @user = FactoryGirl.create(:user) }

  describe "signup for html" do

    describe "failure should not make a new user" do
      it "if name field is empty" do
        lambda do
          visit new_user_registration_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => "admin@mail.ru"
          fill_in "Password",     :with => @user.password
          fill_in "Password confirmation",   :with => @user.password
          click_button 'Sign up'
          page.html.should match("Name can&#39;t be blank")
        end.should_not change(User, :count)
      end

      it "if password field doesn't equal password_confirmation" do
        lambda do
          visit new_user_registration_path
          fill_in "Name",         :with => @user.name
          fill_in "Email",        :with => "admin@mail.ru"
          fill_in "Password",     :with => @user.password
          fill_in "Password confirmation",   :with => "wrong_password"
          click_button 'Sign up'
          page.html.should match("Password confirmation doesn&#39;t match Password")
        end.should_not change(User, :count)
      end

      it "if email format doesn't equal certain pattern" do
        lambda do
          visit new_user_registration_path
          fill_in "Name",         :with => @user.name
          fill_in "Email",        :with => "admin@mail.ru3213"
          fill_in "Password",     :with => @user.password
          fill_in "Password confirmation",   :with => @user.password
          click_button 'Sign up'
          page.html.should match("Email is invalid")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should make a new user" do
        lambda do
          visit new_user_registration_path
          fill_in "Name",         :with => @user.name
          fill_in "Email",        :with => "admin@mail.ru"
          fill_in "Password",     :with => @user.password
          fill_in "Password confirmation", :with => @user.password
          click_button 'Sign up'
          page.html.should match("A message with a confirmation link has been sent to your email address. Please open the link to activate your account.")
        end.should change(User, :count).by(1)
      end
    end
  end
=begin
  describe "signup for json" do

    describe "failure" do
      it "should not make a new user" do
        lambda do
          post "/user_sign_up", :username => "jdoe", :password => "secret", :password_confirmation => "secret"
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should make a new user" do
        lambda do
          visit new_user_registration_path
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Password confirmation", :with => "foobar"
          click_button 'Sign up'
          page.html.should match("A message with a confirmation link has been sent to your email address. Please open the link to activate your account.")
        end.should change(User, :count).by(1)
      end
    end
  end
=end
  describe "sign in/out" do

    describe "failure" do
      it "should not sign a user in with wrong email" do
        visit new_user_session_path
        fill_in "Email",    :with => "wrong@email.net"
        fill_in "Password", :with => @user.password
        click_button 'Sign in'
        page.html.should match("Invalid email or password.")
      end

      it "should not sign a user in with wrong password" do
        visit new_user_session_path
        fill_in "Email",    :with => @user.email
        fill_in "Password", :with => "wrong password"
        click_button 'Sign in'
        page.html.should match("Invalid email or password.")
      end

      it "should not sign a user if email is inactive" do
        visit new_user_session_path
        fill_in "Email",    :with => @user.email
        fill_in "Password", :with => @user.password
        click_button 'Sign in'
        page.html.should match("You have to confirm your account before continuing.")
      end
    end

    describe "success" do
      it "should sign a user in and out" do
        @user.confirm!
        visit new_user_session_path
        fill_in "Email",    :with => @user.email
        fill_in "Password", :with => @user.password
        click_button 'Sign in'
        page.html.should match("Signed in successfully.")
        click_link 'Logout'
        page.html.should match("Signed out successfully.")
      end
    end
  end
end
