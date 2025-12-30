class AddStatusCreatedAtToToots < ActiveRecord::Migration[8.1]
  def change
    add_column :toots, :status_created_at, :timestamp, null: false
  end
end
