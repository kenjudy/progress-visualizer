require 'bcrypt'

class User < ActiveRecord::Base
  # users.password_hash in the database is a :string
  include BCrypt

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
   validates :name, :email, presence: true
   validates :name, :email, uniqueness: true


end