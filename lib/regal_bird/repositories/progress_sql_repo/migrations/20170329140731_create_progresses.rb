Sequel.migration do
  up do
    create_table(:progresses) do
      primary_key :id
      String :progress_id, size: 36, unique: true, null: false
      String :state, null: false
      String :plan, null: false
    end
  end

  down do
    drop_table(:progresses)
  end

end