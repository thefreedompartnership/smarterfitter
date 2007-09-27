require "digest/sha1"
class Chain < ActiveRecord::Base
  has_many :days, :order => "days.when"
  composed_of :tz, :class_name => 'TZInfo::Timezone', :mapping => %w(time_zone identifier), :allow_nil => true
  
  def before_create
    self.key = Digest::SHA1.hexdigest(self.name + DateTime.now.to_s)
    self.read_key = Digest::SHA1.hexdigest(self.name + DateTime.now.to_s + rand.to_s)
  end
  
  def has_day?(date)
    get_days_hash[date]
  end
  
  def first_day    
    return nil if days.size == 0
    if new_record?
      (days.min {|a, b| a.when <=> b.when}).when
    else
      days.minimum("days.when")
    end
  end
  
  def last_day
    return nil if days.size == 0
    if new_record?
      (days.max {|a, b| a.when <=> b.when}).when
    else
      days.maximum("days.when")
    end
  end
  
  def years_and_months
    fd = first_day
    ld = last_day
    result = []
    fd.year.upto(ld.year) do |year|
      if year == fd.year && year == ld.year
        result << { :year => year, :months => (fd.month..ld.month).collect }
      elsif year == fd.year
        result << { :year => year, :months => (fd.month..12).collect }      
      elsif year == ld.year
        result << { :year => year, :months => (1..ld.month).collect }
      else
        result << { :year => year, :months => (1..12).collect }
      end
    end
    result
  end
  
  def update_day(date)
    should_add_day = true
    if (new_record? && days.detect {|d| d.when == date}) ||
       (!new_record? && days.find_by_when(date))
      should_add_day = false
    end

    if should_add_day
      added = true
      days << Day.new(:when => date)
    else
      added = false
      if new_record?
        days.delete_if { |day| day.when == date }
      else
        days.find_by_when(date).destroy
      end
    end
    reset_days_hash
    added    
  end
  
  private
  
  def get_days_hash
    if @days_hash.nil?
      @days_hash = {}
      days.each {|day| @days_hash[day.when] = day}
    end
    @days_hash
  end
  def reset_days_hash
    @days_hash = nil
  end
  
end
