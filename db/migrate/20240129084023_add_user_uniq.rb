class AddUserUniq < ActiveRecord::Migration[7.1]
  def change
    change_table :users do |t|
      t.index :username, unique: true
    end
  end
end
