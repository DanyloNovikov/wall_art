# frozen_string_literal: true

class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :collection_name, :plate_name, :created_at

  def collection_name
    object.collection&.title
  end

  def plate_name
    object.plate&.title
  end
end
