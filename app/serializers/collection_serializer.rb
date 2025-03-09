# frozen_string_literal: true

class CollectionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :publish, :images

  has_many :plates

  def images
    object.images.map { |image| Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true) } if object.images.attached?
  end
end
