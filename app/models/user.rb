class User < ActiveRecord::Base
  has_many :user_profiles, :dependent => :delete_all

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:trello, :twitter]
         
  validates :name, :email, presence: true
  validates :name, :email, uniqueness: true

  def default_profile
    user_profiles.where("user_profiles.default = ?", "1").first
  end
  
  def self.find_for_trello_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name
    end
  end
  
  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.uid + "@twitter.com").first
      if registered_user
        return registered_user
      else

        user = User.create(name:auth.extra.raw_info.name,
                            provider:auth.provider,
                            uid:auth.uid,
                            email:auth.uid+"@twitter.com",
                            password:Devise.friendly_token[0,20],
                          )
      end

    end
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.trello_data"] && session["devise.trello_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end