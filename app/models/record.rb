class Record < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 100}, format: {with: VALID_EMAIL_REGEX}, uniqueness: { scope: :event }
  validates :name, presence: true, length: {maximum: 50}
  validates :surname, presence: true, length: {maximum: 50}

  before_save { self.email = email.downcase }

  belongs_to :event, counter_cache: true
end
