class BodyMass < ActiveRecord::Base

  before_save :normalize_mass
  after_save :denormalize_mass
  after_find :denormalize_mass

  belongs_to :user
  
  validates_presence_of     :mass, :recorded_at
  validates_numericality_of :mass
  validates_inclusion_of    :mass,
                            :in => 1..1000,
                            :message => "should be more than 0"

  def normalize_mass
    self.mass = self.mass / 2.20462262 unless user.measurement_system == "metric"
  end
  
  def denormalize_mass
    self.mass = (self.mass * 2.20462262).round unless user.measurement_system == "metric"
  end
  
  def after_find
    #empty to trigger after_find
  end
  
  
end
