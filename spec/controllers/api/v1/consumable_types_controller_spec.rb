require 'rails_helper'

describe Api::V1::ConsumableTypesController, type: :request do

  describe "GET #show" do

    it "should return a serialized Consumable Type by id" do
      consumable_type = create(:consumable_type_with_ingredients)

      get api_v1_consumable_type_path(consumable_type)
      expect(response).to be_success

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:id]).to eq(consumable_type.id)
      expect(json[:name]).to eq(consumable_type.name)
      expect(json[:days_to_keep]).to eq(consumable_type.days_to_keep)
      expect(json[:expiry_date_from_today]).to eq(consumable_type.expiry_date_from_today)
      expect(json[:ingredients].length).to eq(consumable_type.ingredients.count)
    end

    context "Consumable Type does not exist" do
      it "should return a 404 with an error message" do
        get api_v1_consumable_type_path(:id => 123)
        expect(response.status).to be(404)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:message]).to eq('Couldn\'t find ConsumableType with \'id\'=123')
      end
    end

  end

  describe 'GET #index' do

    it "should return a serialized list of consumable types" do
      consumable_types = create_list(:consumable_type, 3)

      get api_v1_consumable_types_path
      expect(response).to be_success

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:consumable_types]).to be_kind_of(Array)

      json[:consumable_types].each_with_index do |consumable_type, index|
        expect(consumable_type[:id]).to eq(consumable_types[index].id)
        expect(consumable_type[:name]).to eq(consumable_types[index].name)
        expect(consumable_type[:uri]).to include(api_v1_consumable_type_path(consumable_types[index]))
      end
    end

  end
end