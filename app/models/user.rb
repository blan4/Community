class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :email, type: String
  field :name, type: String
  field :surname, type: String
  #meta fields wich will be added dynamicaly
  
  has_many :participations

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, 
    presence: true,
  	format: { with: VALID_EMAIL_REGEX }, 
  	length: { maximum: 100 }, 
  	uniqueness: { case_sensitive: false }
  validates :name,
  	length: { maximum: 50 }, 
  	presence: true
  validates :surname,
  	length: { maximum: 50 }, 
  	presence: true

  before_save { self.email = email.downcase }

  def events
    Event.in(id: participations.map(&:event_id))
  end
  def categories
    Category.in(id: participations.map(&:category_id))
  end
  def score
    participations.sum(:score)
  end
  def participate!(event, category, score)
    participations.create!(event: event, category: category, score: score)
  end
  def leave!(event)
    participations.destroy_all(event: event)
  end
end
