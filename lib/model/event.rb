require 'dm-validations'
require 'json'

class Event

  include DataMapper::Resource

  property :id,     		  Serial
  property :title,  		  String
  property :description,  Text
  property :date,         DateTime
  property :geometry,     Object
  property :timescale,    String
  property :startdate,    DateTime
  property :enddate,      DateTime

  has n, :tags,   :through => Resource
  has n, :events, :through => Resource



  validates_presence_of :title, :description, :geometry

  def export_geojson
    to_geojson_feature.to_json
  end

  def to_geojson_feature
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

