# frozen_string_literal: true

class PlateSerializer < ActiveModel::Serializer
  attributes :id, :title, :order, :collection_name, :image_url, :created_at

  def collection_name
    object.collection&.title
  end

  def image_url
    return unless object.image.attached?

    Rails.application.routes.url_helpers.rails_blob_url(
      object.image,
      only_path: true
    )
  end
end
