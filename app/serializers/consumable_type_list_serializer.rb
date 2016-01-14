class ConsumableTypeListSerializer < ActiveModel::Serializer

  attributes :id, :name, :uri

  def uri
    scope.api_v1_consumable_type_url(object)
  end

end
