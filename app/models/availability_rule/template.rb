# A template which assigns a set of standard AvailabilityRules to a target.
class AvailabilityRule::Template
  attr_reader :id, :name, :days, :hours, :description

  def initialize(options)
    @id      = options[:id]
    @name    = options[:name]
    @days    = options[:days]
    @hours   = options[:hours]
    @description = options[:description]
  end

  def full_name
    "#{name} (#{description})"
  end

  def apply(target)
    # Flag existing availability rules for destruction
    target.availability_rules.each(&:mark_for_destruction)

    @days.each do |day|
      target.availability_rules.build(
        :day => day,
        :open_hour => @hours.begin,
        :open_minute => 0,
        :close_hour => @hours.end,
        :close_minute => 0
      )
    end
  end

  def includes_rule?(rule)
    @days.include?(rule.day) && @hours.begin == rule.open_hour && @hours.end == rule.close_hour &&
      rule.open_minute == 0 && rule.close_minute == 0
  end
end
