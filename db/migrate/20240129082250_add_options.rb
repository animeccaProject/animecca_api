class AddOptions < ActiveRecord::Migration[7.1]
  def change
    change_table :favorites do |t|
      t.change :user_id, :integer, null: false
      t.change :mecca_id, :integer, null: false
    end
    
    change_table :images do |t|
      t.change :path, :string, null: false
      t.change :mecca_id, :integer, null: false
    end

    change_table :meccas do |t|
      t.change :mecca_name, :string, null: false
      t.change :anime_id, :integer, null: false
      t.change :title, :string, null: false
      t.change :place_id, :integer, null: false
      t.change :prefecture, :string, null: false
      t.change :user_id, :integer, null: false
    end

    change_table :users do |t|
      t.change :username, :string, null: false
      t.change :password_digest, :string, null: false
    end
  end
end
