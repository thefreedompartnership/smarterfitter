require "digest/sha1"
class Chain < ActiveRecord::Base
  has_many :days
  composed_of :tz, :class_name => 'TZInfo::Timezone', :mapping => %w(time_zone identifier), :allow_nil => true
  
  def before_create
    self.key = Digest::SHA1.hexdigest(self.name + DateTime.now.to_s)
    self.read_key = Digest::SHA1.hexdigest(self.name + DateTime.now.to_s + rand.to_s)
  end
end
