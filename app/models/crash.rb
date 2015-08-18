class Crash < ActiveRecord::Base
  belongs_to :crash_group, foreign_key: 'crash_group_id', primary_key: 'hockey_id'
end
