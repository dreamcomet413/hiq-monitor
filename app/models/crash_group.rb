class CrashGroup < ActiveRecord::Base
  acts_as_taggable

  STATUS = %w(Unresolved Tracked Resolved Ignored)
  has_many :crashes, foreign_key: 'crash_group_id', primary_key: 'hockey_id'
end
