class CreateChallenges < ActiveRecord::Migration[8.1]
  def change
    create_table :challenges do |t|
      t.integer :year, null: false
      t.integer :week, null: false
      t.integer :category, null: false
      t.integer :difficulty, null: false
      t.text :summary, null: false
      t.text :description

      t.timestamps
    end
  end
end
