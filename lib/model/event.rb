class Event

  include DataMapper::Resource

  property :id,     		Serial
  property :title,  		String
  property :description,    Text
  property :category,    	String
  property :date,    		DateTime
  property :geometry,    	Object

end