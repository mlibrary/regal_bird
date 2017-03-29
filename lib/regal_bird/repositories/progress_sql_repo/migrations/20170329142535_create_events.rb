Sequel.migration do
  up do
    create_table(:events) do
      primary_key :id
      foreign_key :progress_id, :progresses, key: :id,
        on_delete: :cascade,
        on_update: :cascade
      String :action, null: false
      String :state, null: false
      String :data, text: true, null: false
      Time :start_time, null: false
      Time :end_time, null: false
    end
  end

  down do
    drop_table(:events)
  end

end