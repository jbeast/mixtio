require "rails_helper"

RSpec.describe ApplicationController, type: :controller do

  controller do
    include ApiPagination

    def index
      with_pagination(Batch.page(params[:page])) do |b|
        render nothing: true
      end
    end
  end

  let!(:page_size) { Batch.default_per_page }

  subject { response.headers["Link"].split(", ") }

  context "when there are multiple pages" do

    before { create_list(:batch, page_size * 3) }

    context "navigate to first page" do

      before { get :index, page: 1 }

      it "adds a link for the next page" do
        expect(subject).to include("<http://test.host/anonymous?page=2>; rel=\"next\"")
      end

      it "adds a link for the last page" do
        expect(subject).to include("<http://test.host/anonymous?page=3>; rel=\"last\"")
      end

    end

    context "navigate to last page" do

      before { get :index, page: 3 }

      it 'adds a link for the previous page' do
        expect(subject).to include("<http://test.host/anonymous?page=2>; rel=\"prev\"")
      end

      it 'adds a link for the first page' do
        expect(subject).to include("<http://test.host/anonymous?page=1>; rel=\"first\"")
      end

    end

  end
end