class Api::V1::ConsumableTypesController < Api::V1::ApiController

  def show
    render json: ConsumableType.find(params[:id])
  end

  def index
    with_pagination ConsumableType.page(params[:page]) do |consumable_types|
      render json: consumable_types, each_serializer: ConsumableTypeListSerializer
    end
  end

end
