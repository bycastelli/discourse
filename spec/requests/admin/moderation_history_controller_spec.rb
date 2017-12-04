require 'rails_helper'

RSpec.describe Admin::BackupsController do
  let(:admin) { Fabricate(:admin) }

  before do
    sign_in(admin)
  end

  describe "parameters" do
    it "returns 404 without a valid filter" do
      get "/admin/moderation_history.json"
      expect(response).not_to be_success
    end

    it "returns 404 without a valid id" do
      get "/admin/moderation_history.json?filter=topic"
      expect(response).not_to be_success
    end
  end

  describe "for a post" do
    it "returns a JSON history" do
      get "/admin/moderation_history.json?filter=post&post_id=1234"
      expect(response).to be_success
    end
  end
end
