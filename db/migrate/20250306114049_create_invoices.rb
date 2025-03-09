# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices, id: :uuid do |t|
      t.string :name
      t.string :surname
      t.string :phone
      t.references :collection, type: :uuid, null: false, foreign_key: true
      t.references :plate, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
