class Crash < ActiveRecord::Base
  belongs_to :crash_group, foreign_key: 'crash_group_id', primary_key: 'hockey_id'

  def self.daily_count(from, to)
    all.group_by_day(:hockey_created_at, range: from..to).count.map { |date, count| [(date.to_f * 1000).to_i, count] }
  end
end
