require "rails_helper"

RSpec.describe Api::MessagesController, type: :controller do
  context "#create" do
    context "with invalid data" do
      it "returns not_acceptable (406)" do
        post :create, params: { message: "<html>" }, format: :html
        expect(response.status).to be 406
      end
    end

    context "with valid data" do
      let(:message) {
        {
          user: { name: "fake-name" },
          content: "fake-content"
        }
      }

      let(:data) {
        {
          params: { message: message },
          format: :json
        }
      }

      it "creates the message" do
        expect { post :create, data }.to change {
          Message.count
        }.from(0).to(1)
      end
    end
  end
end
