class Event
  include Mongoid::Document
  field :name, type: String
  field :date, type: DateTime
  field :place, type: String

  has_many :registrations

  validates :name,
  	presence: true,
  	length: { maximum: 50 }, 
  	uniqueness: { case_sensitive: false }
  validates :date,
  	presence: true
  
  def users
    User.in(id: real_registrations.map(&:user_id))
  end
  def real_users
    User.in(id: real_registrations.map(&:user_id))
  end
  def fake_users
    User.in(id: fake_registrations.map(&:user_id))
  end
  def categories
    Category.in(id: participations.map(&:category_id))
  end
  def participations
    Participation.in(registration: real_registrations.map(&:id))  
  end
 # def invite!(user, category, score)
 #   participations.create!(user: user, category: category, score: score)
 # end
 # def exclude!(user)
 #   participations.destroy_all(user: user)
 # end
  def fake_registrations
    registrations.where(was: false)
  end
  def real_registrations
    registrations.where(was: true)
  end
  def registrate!(user)
    registrations.create!(user: user, was: true)
  end
  def unregistrate(user)
    registrations.delete(user)
  end
end