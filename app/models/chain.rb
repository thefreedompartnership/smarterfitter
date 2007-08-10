require "digest/sha1"
class Chain < ActiveRecord::Base
  has_many :days
  def before_create
    self.key = Digest::SHA1.hexdigest(self.name + DateTime.now.to_s)
  end
#  def to_param
#    self.key
#  end
end
