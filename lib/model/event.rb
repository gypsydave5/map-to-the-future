require 'dm-validations'
require_relative './helpers/event_helpers'

class Event

  include DataMapper::Resource
  include EventHelpers

  property :id,     		  Serial
  property :title,  		  String
  property :description,  Text
  property :geometry,     Object
  property :timescale,    String
  property :startdate,    DateTime
  property :enddate,      DateTime

  has n, :tags,   :through => Resource
  has n, :events, :through => Resource

  validates_presence_of :title, :description, :geometry, :startdate, :enddate

end

