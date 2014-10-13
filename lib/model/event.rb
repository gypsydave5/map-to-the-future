require 'dm-validations'
require 'json'

class Event

  include DataMapper::Resource

  property :id,     		  Serial
  property :title,  		  String
  property :description,  Text
  property :category,    	String
  property :date,         DateTime
  property :geometry,    	Object

  validates_presence_of :title, :description, :geometry

  def export_geojson
    geojson_feature_hash.to_json
  end

  def geojson_feature_hash
    {
      type: "Feature",
      properties: {
        title: self.title,
        description: self.description,
        date: self.date
      },
      geometry: self.geometry
    }
  end

end

