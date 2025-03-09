# frozen_string_literal: true

class CreatePlates < ActiveRecord::Migration[8.0]
  def change
    create_table :plates, id: :uuid do |t|
      t.string :title
      t.integer :order
      t.references :collection, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
