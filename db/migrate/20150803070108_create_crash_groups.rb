class CreateCrashGroups < ActiveRecord::Migration
  def change
    create_table :crash_groups do |t|
      t.string :file
      t.string :reason
      t.string :status
      t.string :hockey_id
      t.string :crash_class
      t.string :bundle_version
      t.string :last_crash_at
      t.string :app_version_id
      t.string :method
      t.string :bundle_short_version
      t.integer :number_of_crashes
      t.integer :line
      t.boolean :fixed
      t.datetime :hockey_updated_at
      t.datetime :hockey_created_at

      t.timestamps null: false
    end
  end
end