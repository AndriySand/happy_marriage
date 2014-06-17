  require 'spec_helper'

describe TasksController do
  render_views  

  describe "every user " do

    it "should be successful to get the welcome page" do
      visit root_path
      page.html.should match("Login")
    end
  end

  describe "the user who signed in" do

    before(:each) do
      user = FactoryGirl.create(:user)
      visit new_user_session_path
      fill_in "Email",    :with => user.email
      fill_in "Name",    :with => user.name
      fill_in "Password", :with => user.password
      click_button 'Sign in'
      task = FactoryGirl.create(:task)
      #sign_in @user
      #sign_out user
    end

    it "get the list of his tasks" do    	
      page.html.should match("Listing tasks")
    end

    it "can create the task" do
      lambda do
        visit new_task_path
        fill_in "Title",    :with => 'title1'
        fill_in "Body",    :with => 'main text'
        click_button 'Create Task'      
        page.html.should match("Task was successfully created")
      end.should change(Task, :count).by(1)
    end

	it "can delete the task" do
	  lambda do
        visit tasks_path      
        click_link "Destroy"
      end.should change(Task, :count).by(-1)
    end

    it "can edit the task" do
      visit tasks_path
      click_link "Edit"
      fill_in "Title",    :with => 'title2'
      fill_in "Body",    :with => 'main text is here'
      click_button "Update Task"
      page.html.should match("Task was successfully updated")
    end
    
    it "can watch the tasks which have deadline today" do
      visit deadline_today_path
      page.html.should match("Tasks which have deadline today")
    end
  end
end
