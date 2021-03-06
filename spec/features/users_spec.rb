# As an admin I want to be able to create new users in the system and edit them in order to allow users to be tracked in the system.
require "rails_helper"

RSpec.describe "Users", type: :feature do

  let!(:teams)            { create_list(:team, 2)}

  it "Allows a user to create a new user" do
    user = build(:user)
    visit users_path
    click_link "Add new user"
    expect {
      fill_in "Username", with: user.username
      select teams.first.name, from: "Team"
      click_button "Create User"
    }.to change(User, :count).by(1)
    expect(page).to have_content("User successfully created")
  end

  it "Allows a user to edit an existing user" do
    user = create(:user)
    visit edit_user_path(user)
    expect {
      uncheck "Active"
      click_button "Update User"
    }.to change { user.reload.active? }
  end

  it "Reports an error if the user adds a user with invalid attributes" do
    user = build(:user)
    visit users_path
    click_link "Add new user"
    expect {
      select teams.first.name, from: "Team"
      click_button "Create User"
    }.to_not change(User, :count)
    expect(page).to have_content("error prohibited this record from being saved")
  end

  it "Allows a user to create a new administrator" do
    user = build(:user)
    visit users_path
    click_link "Add new user"
    expect {
      fill_in "Username", with: user.username
      select "Administrator", from: "Type"
      select teams.first.name, from: "Team"
      click_button "Create User"
    }.to change(Administrator, :count).by(1)
    expect(page).to have_content("User successfully created")
  end

end
