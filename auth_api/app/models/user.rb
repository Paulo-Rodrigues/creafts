class User < ApplicationRecord
  has_secure_password

  before_create :set_external_id

  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "is not a valid email" },
            uniqueness: { case_sensitive: false }

  private

  def set_external_id
    self.external_id = SecureRandom.uuid
  end
end
