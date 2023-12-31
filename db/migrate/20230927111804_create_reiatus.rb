class CreateReiatus < ActiveRecord::Migration[7.0]
  def change
    create_table :reiatus do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
    add_index :reiatus, [:user_id, :post_id], unique: :true
  end
end
