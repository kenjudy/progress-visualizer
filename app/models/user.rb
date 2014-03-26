class User < ActiveRecord::Base
  has_many :user_profiles, :dependent => :delete_all

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:trello, :twitter, :google_oauth2]

  validates :name, :email, presence: true
  validates :name, :email, uniqueness: true

  def default_profile
    user_profiles.where("user_profiles.default = ?", "1").first
  end

  def self.find_for_trello_oauth(auth)
    find_for_provider_oauth(auth)
  end

  def self.find_for_twitter_oauth(auth)
    find_for_provider_oauth(auth, {email: auth.uid+"@twitter.com"})
  end
  
  def self.find_for_google_oauth2(auth)
    find_for_provider_oauth(auth, {email: auth.email, name: auth.name})
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.trello_data"]
        user.name = data["info"]["name"] if user.name.blank?
        user.email = data["info"]["email"] if user.email.blank?
      elsif data = session["devise.twitter_data"]
        user.name = data["info"]["name"] if user.name.blank?
      end
    end
  end
  
  private
  
  def self.find_for_provider_oauth(auth, options = {})
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = options[:email] || auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = options[:name] || auth.info.name
    end
  end
end