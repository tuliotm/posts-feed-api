class CreatePublications < ActiveRecord::Migration[7.0]
  def change
    create_table :publications do |t|
      t.string :title, null: false
      t.text :description
      t.text :files
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
