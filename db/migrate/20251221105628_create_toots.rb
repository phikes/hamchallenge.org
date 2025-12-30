class CreateToots < ActiveRecord::Migration[8.1]
  def change
    create_table :toots do |t|
      t.references :challenge, null: false, foreign_key: true
      t.boolean :completed, null: false
      t.boolean :direct, null: false
      t.string :username, null: false
      t.string :url, null: false
      t.text :summary, null: false

      t.timestamps

      t.index %i[challenge_id url], unique: true
    end
  end
end
