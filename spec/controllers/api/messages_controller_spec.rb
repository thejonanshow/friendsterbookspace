require "rails_helper"

RSpec.describe Api::MessagesController, type: :controller do
  context "#create" do
    context "without an api_key" do
      let(:message) {
        {
          user: { name: "fake-name" },
          content: "fake-content",
        }
      }

      let(:data) {
        {
          params: {
            message: message
          },
          format: :json
        }
      }

      it "returns unauthorized (401)" do
        post :create, data
        expect(response.status).to be 401
      end
    end

    context "with valid data" do
      let(:message) {
        {
          user: { name: "fake-name" },
          content: "fake-content",
        }
      }

      let(:data) {
        {
          params: {
            message: message,
            api_key: ENV["MESSAGES_API_KEY"]
          },
          format: :json
        }
      }

      it "creates the message" do
        expect { post :create, data }.to change {
          Message.count
        }.from(0).to(1)
      end

      it "without a room uses the default room" do
        post :create, data
        expect(Message.last.room).to eql Room.default
      end

      context "with a room slug" do
        let(:room) { Fabricate(:room) }

        before do
          message[:room] = { slug: room.slug }
        end

        it "with a room uses the supplied room" do
          post :create, data
          expect(Message.last.room).to eql room
        end
      end
    end
  end
end
