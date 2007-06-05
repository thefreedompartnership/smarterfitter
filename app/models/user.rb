require "digest/sha1"
class User < ActiveRecord::Base
  
  has_many :runs
  
  
  attr_accessor :password, :confirm_password
  
  validates_uniqueness_of :user_name
  validates_presence_of :user_name, :email_address, :first_name, :last_name, :password
  
  composed_of :tz, :class_name => 'TZInfo::Timezone', :mapping => %w(time_zone identifier)

  def validate_on_create
    if password != confirm_password
      errors.add(:confirm_password, "is does not match your password")
    end
  end
  
  #authentication methods
  def self.login(user_name, password)
    hashed_password = hash_password(password || "")
    find(:first,
         :conditions => ["user_name = ? and hashed_password = ?", user_name, hashed_password])
  end
  
  def try_to_login
    User.login(self.user_name, self.password)
  end
  
  
  #lifecycle callback methods
  
  def before_create
    self.hashed_password = User.hash_password(self.password)
  end
  
  def after_create
    @password = nil
  end
  
  private
  def self.hash_password(password)
    Digest::SHA1.hexdigest(password)
  end
  
end
