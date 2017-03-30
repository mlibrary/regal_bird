class CreateProgresses < ActiveRecord::Migration[5.0]
  def up
    create_table :progresses do |t|
      t.string :domain_id, limit: 36, unique: true, null: false
      t.string :state, null: false
      t.string :plan, null: false
    end
  end

  def down
    drop_table :progresses
  end

end