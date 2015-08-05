class CreateCrashes < ActiveRecord::Migration
  def change
    create_table :crashes do |t|
      t.references :crash_group
      t.integer    :hockey_id
      t.integer   :hockey_app_id
      t.integer   :hockey_version_id
      t.datetime  :hockey_created_at
      t.datetime  :hockey_updated_at
      t.integer    :hockey_crash_group_id
      t.string    :oem
      t.string    :model
      t.integer   :bundle_version
      t.string    :bundle_short_version
      t.string    :os_version
      t.boolean   :jail_break
      t.string    :contact
      t.string    :user
      
      t.timestamps null: false
    end
  end
end