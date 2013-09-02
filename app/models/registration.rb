class Registration
  include Mongoid::Document
  field :was, type: Boolean, default: true
  field :newcomer, type: Boolean

  belongs_to :event
  belongs_to :user
  has_many :participations, dependent: :delete

  index({user: 1, event: 1}, {unique: true})

  validates :was,
  	presence: true
  validates :user,
    presence: true 
  validates :event,
    presence: true
  validates :user_id,
    uniqueness: { scope: :event_id }
  validates :newcomer,
    presence: true

  def self.fakes 
  	Registration.where(was: false)
  end
  def self.reals
  	Registration.where(was: true)
  end
  def categories
  	Category.in(id: participations.map(&:category_id))
  end
  def score
  	participations.sum(:score)
  end
  def participate!(category, score)
    part = participations.find_or_initialize_by(category: category)
    part.score = score
    part.save
  end
  def unparticipate!
    participations.delete_all
  end
end

