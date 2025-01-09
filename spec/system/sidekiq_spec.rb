require 'rails_helper'

RSpec.describe "Sidekiq", type: :system do
  describe "sidekiq" do
    it "開ける" do
      visit "/sidekiq"

      expect(page).to have_content "Sidekiq"
    end
  end
end
