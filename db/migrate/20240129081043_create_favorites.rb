class CreateFavorites < ActiveRecord::Migration[7.1]
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :mecca_id

      t.timestamps
    end
    add_foreign_key :favorites, :users, column: :user_id, on_delete: :cascade
    add_foreign_key :favorites, :meccas, column: :mecca_id, on_delete: :cascade
  end
end
