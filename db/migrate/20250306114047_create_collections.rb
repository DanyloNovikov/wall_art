class CreateCollections < ActiveRecord::Migration[8.0]
  def change
    create_table :collections, id: :uuid do |t|
      t.string :title
      t.text :description
      t.boolean :publish

      t.timestamps
    end
  end
end
