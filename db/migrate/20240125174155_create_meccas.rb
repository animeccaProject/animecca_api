class CreateMeccas < ActiveRecord::Migration[7.1]
  def change
    create_table :meccas do |t|
      t.string :mecca_name
      t.integer :anime_id
      t.string :title
      t.integer :episode
      t.time :scene
      t.integer :place_id
      t.string :prefecture
      t.text :about
      t.integer :user_id

      t.timestamps
    end
    add_foreign_key :meccas, :users, column: :user_id, on_delete: :cascade
  end
end
