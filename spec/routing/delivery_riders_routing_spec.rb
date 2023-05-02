require "rails_helper"

RSpec.describe DeliveryRidersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/delivery_riders").to route_to("delivery_riders#index")
    end

    it "routes to #new" do
      expect(get: "/delivery_riders/new").to route_to("delivery_riders#new")
    end

    it "routes to #show" do
      expect(get: "/delivery_riders/1").to route_to("delivery_riders#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/delivery_riders/1/edit").to route_to("delivery_riders#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/delivery_riders").to route_to("delivery_riders#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/delivery_riders/1").to route_to("delivery_riders#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/delivery_riders/1").to route_to("delivery_riders#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/delivery_riders/1").to route_to("delivery_riders#destroy", id: "1")
    end
  end
end
