require 'dm-validations'

class Link

  include DataMapper::Resource

  property :id,           Serial
  property :name,         String
  property :url,         String

  belongs_to :event

end
