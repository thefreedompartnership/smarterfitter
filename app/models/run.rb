class Run < ActiveRecord::Base
  
  attr_accessor :distance, :duration
  
  belongs_to :user
    
  validates_presence_of :when_run

  METERS_PER_MILE = 1609.334
  METERS_PER_KILOMETER = 1000

  def run_title()
    return run.when_run ": "  + run.distance + "km in " + run.duration + " minutes"
  end
  
  def duration
    Run.duration_in_seconds_as_string(self.duration_in_seconds)
  end
  
  def duration=(new_duration)
    self.duration_in_seconds = Run.duration_in_seconds_from_string(new_duration)
  end
  
  def duration_before_type_cast
    return self.duration
  end
  
  def self.duration_in_seconds_from_string(new_duration)
    if new_duration.nil? || new_duration.to_s.squeeze(" ") == "" then 
      return nil
    end
    hours, minutes, seconds = 0
    if new_duration =~ /\d+\D+\d+\D+\d+\D+/ then
      hours, minutes, seconds = new_duration.scan(/\d+/)
    elsif new_duration =~ /\d+\D+\d+.*s.*/ then
      minutes, seconds = new_duration.scan(/\d+/)
    elsif new_duration =~ /\d+\D+\d+\D+/ then
      hours, minutes = new_duration.scan(/\d+/)
    elsif new_duration =~ /\d+.*h.*/ then
      hours = new_duration.scan(/\d+/)[0]
    elsif new_duration =~ /\d+.*m.*/ then
      minutes = new_duration.scan(/\d+/)[0]
    elsif new_duration =~ /\d+.*s.*/ then
      seconds = new_duration.scan(/\d+/)[0]
    else
      minutes = new_duration.to_i
    end
    return hours.to_i * 3600 + minutes.to_i * 60 + seconds.to_i
  end
  
  def self.duration_in_seconds_as_string(duration_in_seconds)
    if duration_in_seconds.nil? then 
      "" 
    else
      hours = duration_in_seconds.div(3600)
      minutes = duration_in_seconds.modulo(3600).div(60)
      seconds = duration_in_seconds.modulo(60)
      
      result = ""
      result += sprintf("%d hr ", hours) unless hours == 0
      result += sprintf("%d min", minutes) unless hours == 0 && minutes == 0
      result += " " unless (hours == 0 && minutes == 0) || seconds == 0
      result += sprintf("%d sec", seconds) unless seconds == 0
      return result
    end
  end
  
  def distance
    if self.distance_in_meters == nil
      return nil
    end
    multiplier = 
    if distance_unit == 'miles'
      METERS_PER_MILE
    else
      METERS_PER_KILOMETER
    end
    return Float(((Float(self.distance_in_meters) / multiplier) * 1000).round()) / 1000
  end
 
  def distance=(new_distance)
    multiplier = 
    if distance_unit == 'miles'
      METERS_PER_MILE
    else
      METERS_PER_KILOMETER
    end
    if ! new_distance.nil? && new_distance.to_s != "" then
      self.distance_in_meters = Integer(Float(new_distance) * multiplier)
    else
      self.distance_in_meters = nil
    end
  end
  
  def distance_before_type_cast
    return self.distance
  end
  
      
end
