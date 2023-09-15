class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :kaigo
      t.string :kaigo_hurigana
      t.string :shikai, null: false
      t.string :shikai_hurigana
      t.text :ability, null: false
      t.string :bankai
      t.string :bankai_hurigana
      t.text :bankai_ability
      t.string :image
      t.text :detail
      t.boolean :is_draft, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
