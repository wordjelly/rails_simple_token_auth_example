class User
  include Mongoid::Document

  before_save :filter_fields
  before_save do |document|
    document.set_es
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  field :name,               type: String, default: ""
  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  acts_as_token_authenticatable
  field :authentication_token




  #redirect url field, this is never persisted.
  field :redirect_url

  ##email salt
  ##generated before_save
  ##built by prepending a SECURERANDOM SALT to the email, and then 
  ##running SHA256 on it.
  ##this is used as the user identifier key in the config for the 
  ##simple_token_authentication gem.
  ##refer method : set_es
  field :es

  protected

  def set_es
    if !email.nil?
      salt = SecureRandom.hex(32)
      pre_es = salt + email
      self.es = Digest::SHA256.hexdigest(pre_es)
    end
  end


  def filter_fields
    remove_attribute(:redirect_url)
    attributes
  end

end
