# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :collection
  belongs_to :plate

  after_create :send_notification

  validates :name, :surname, :phone, presence: true

  private

  def send_notification
  end
end
