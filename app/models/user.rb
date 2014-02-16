class User < ActiveRecord::Base
  has_many :user_profiles, :dependent => :delete_all

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates :name, :email, presence: true
  validates :name, :email, uniqueness: true

  def default_profile
    user_profiles.where("user_profiles.default = ?", "1").first
  end
end