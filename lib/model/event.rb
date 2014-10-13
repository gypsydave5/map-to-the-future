require 'dm-validations'

class Event

  include DataMapper::Resource

  property :id,     		Serial
  property :title,  		String
  property :description,    Text
  property :category,    	String
  property :date,    		DateTime
  property :geometry,    	Object

validates_presence_of :title, :description, :geometry



end

