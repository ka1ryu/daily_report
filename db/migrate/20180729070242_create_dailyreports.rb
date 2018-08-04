class CreateDailyreports < ActiveRecord::Migration[5.2]
  def change
    create_table :dailyreports do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :dailyreports, [:user_id,:created_at]
  end
end
