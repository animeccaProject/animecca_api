class ChangeSceneType < ActiveRecord::Migration[7.1]
  def change
    change_column :meccas, :scene, :string
  end
end
