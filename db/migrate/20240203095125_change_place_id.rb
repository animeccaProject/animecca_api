class ChangePlaceId < ActiveRecord::Migration[7.1]
  def change
    change_column :meccas, :place_id, :string
  end
end
