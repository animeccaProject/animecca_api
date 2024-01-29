class CreateImages < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |t|
      t.string :path
      t.integer :mecca_id

      t.timestamps
    end
    add_foreign_key :images, :meccas, column: :mecca_id, on_delete: :cascade
  end
  
end
