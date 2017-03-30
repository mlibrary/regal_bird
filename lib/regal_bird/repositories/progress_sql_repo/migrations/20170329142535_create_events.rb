class CreateEvents < ActiveRecord::Migration[5.0]
  def up
    create_table :events do |t|
      t.integer :progress_id, null: false
      t.string :action, null: false
      t.string :state, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.text :data
    end
    add_foreign_key :events, :progresses,
      column: :progress_id, primary_key: :id,
      on_delete: :cascade, on_update: :cascade
  end

  def down
    drop_table :events
  end

end