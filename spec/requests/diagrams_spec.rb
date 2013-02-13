require 'spec_helper'

describe "Diagram" do
  describe "GET /diagram/new" do

    it "Should have diagram creation form" do
      visit '/diagram/new'
      page.should have_content('Create a Diagram')
    end

    it "Valid diagram submitted should respond with image" do
      visit '/diagram/new'
      within('#diagram-form') do
      end
    end
  end
end
