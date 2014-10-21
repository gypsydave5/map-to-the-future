require 'dm-validations'
require_relative './helpers/event_helpers'

class Event

  include DataMapper::Resource
  include EventHelpers

  property :id,           Serial
  property :title,        String
  property :description,  Text
  property :geometry,     Object
  property :timescale,    String
  property :startdate,    DateTime
  property :enddate,      DateTime

  has n, :tags,   :through => Resource
  has n, :links
  has n, :events, Event, :through => :linkedevents,  :via => :target
  has n, :linkedevents, :child_key => [:source_id]

  validates_presence_of :title, :description, :geometry, :startdate, :enddate

end

class Linkedevent
  include DataMapper::Resource

 belongs_to :source, 'Event', :key => true
 belongs_to :target, 'Event', :key => true

end

