# frozen_string_literal: true

class Plate < ApplicationRecord
  belongs_to :collection
  has_one_attached :image

  validates :title, presence: true
end
