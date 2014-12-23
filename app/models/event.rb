class Event
  include Mongoid::Document

  field :name,                  type: String, default: ""
  field :property1,             type: String, default: ""
  field :property2,             type: String, default: ""
  field :referer_URL,           type: String, default: ""
  field :domain,           type: String, default: ""
  
  field :created_on,            type: Date, default: Date.today
  field :created_at,            type: Time, default: Time.now
  belongs_to :user

  scope :visible_to, -> (user) { user ? all : where(user_id: user._id)}
  scope :by_domain, -> (domain) { where(domain: domain)}

  def self.by_weekday
    # setting up date objects
    today = Date.today
    monday = today.at_beginning_of_week
    sunday = monday.advance(days: -1)
    tuesday = monday.advance(days: 1)
    wednesday = monday.advance(days: 2)
    thursday = monday.advance(days: 3)
    friday = monday.advance(days: 4)
    saturday =monday.advance(days: 5)

    sunday_count = self.where(created_on: sunday).count
    monday_count =  self.where(created_on: monday).count
    tuesday_count =  self.where(created_on: tuesday).count
    wednesday_count =  self.where(created_on: wednesday).count
    thursday_count =  self.where(created_on: thursday).count
    friday_count =  self.where(created_on: friday).count
    saturday_count =  self.where(created_on: saturday).count

    weekdays = [sunday_count, monday_count, tuesday_count, wednesday_count, thursday_count, friday_count, saturday_count]
    weekdays
  end


end

