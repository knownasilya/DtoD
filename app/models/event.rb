class Event < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name, :description, :location, :event_type, :event_date, :price, :website, :end_date
  
  validates_presence_of :event_date, :name
  validates_length_of :name, :minimum => 3
end
