require 'dm-validations'

class Event

  include DataMapper::Resource

  property :id,           Serial
  property :name,         String

  has n, :events, :through => Resource

  validates_uniqueness_of :name

end

