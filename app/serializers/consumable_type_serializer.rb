class ConsumableTypeSerializer < ActiveModel::Serializer

  self.root = false

  attributes :id, :name, :days_to_keep, :expiry_date_from_today #, :latest_consumables

  has_many :latest_consumables, serializer: ConsumableSerializer

end
