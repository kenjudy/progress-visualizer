class User < ActiveRecord::Base
  has_many :user_profiles, :dependent => :delete_all

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates :name, :email, presence: true
  validates :name, :email, uniqueness: true


end