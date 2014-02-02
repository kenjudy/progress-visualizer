require 'bcrypt'

class User < ActiveRecord::Base
  # users.password_hash in the database is a :string
  include BCrypt
  
   validates :name, :email, :password_hash, presence: true
   validates :name, :email, uniqueness: true

  def password
    return unless password_hash
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
  
  def reset_password
    random_password =  Array.new(10).map { (65 + rand(58)).chr }.join
    password = random_password
    return random_password
  end

end