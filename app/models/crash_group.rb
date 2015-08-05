class CrashGroup < ActiveRecord::Base
  STATUS = %w(Unresolved Tracked Resolved Ignored)
  has_many :crashes
end
