class Event



include DataMapper::Resource

  # This block describes what resources our model will have
  property :id,     		Serial # Serial means that it will be auto-incremented for every record
  property :title,  		String
  property :description,    Text
  property :date,    		DateTime
  property :geometry,    	Object

end