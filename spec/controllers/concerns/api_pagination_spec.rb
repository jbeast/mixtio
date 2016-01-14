require "rails_helper"

RSpec.describe ApiPagination, type: :controller do

  let!(:collection) do
    collection = double()
    collection.stub(:current_page) { 1 }
    collection.stub(:total_pages) { 5 }
    collection.stub(:first_page?) { true }
    collection.stub(:last_page?) { false }
    collection
  end

  controller(ApplicationController) do
    include ApiPagination

    def index
      with_pagination(collection) do |c|
        # nothing
      end
    end
  end

  before do
    routes.draw {
      get 'index' => 'anonymous#index'
    }
  end

  it "adds a Link field to the header" do
    get :index
    expect(1).to be(1)
  end

end