class User
  include Mongoid::Document

  before_save :ensure_authentication_token!
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :events

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

  ## Authentication Token
  field :authentication_token,    type: String, default: ""

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  def self.serialize_from_session(key, salt)
    record = to_adapter.get(key[0]["$oid"])
    record if record && record.authenticatable_salt == salt
  end

  def generate_secure_token_string
    SecureRandom.urlsafe_base64(25).tr('lIO0', 'sxyz')
  end

  # Sarbanes-Oxley Compliance: http://en.wikipedia.org/wiki/Sarbanes%E2%80%93Oxley_Act
  def password_complexity
    if password.present? and not password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W]).+/)
      errors.add :password, "must include at least one of each: lowercase letter, uppercase letter, numeric digit, special character."
    end
  end

  def password_presence
    password.present? && password_confirmation.present?
  end

  def password_match
    password == password_confirmation
  end

  def ensure_authentication_token!
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = generate_secure_token_string
      break token unless User.where(authentication_token: token).first
    end
  end

  def reset_authentication_token!
    self.authentication_token = generate_authentication_token
  end
end
