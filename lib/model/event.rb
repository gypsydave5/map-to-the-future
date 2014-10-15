require 'dm-validations'
require 'json'

class Event

  include DataMapper::Resource

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

  def export_geojson
    to_geojson_feature.to_json
  end

  def to_geojson_feature
    geo_json_hash = {
      type: "Feature",
      properties: {
        id: self.id,
        title: self.title,
        description: self.description,
        startdate: self.startdate,
        enddate: self.enddate,
        timescale: self.timescale
      },
      geometry: self.geometry
    }

    geo_json_hash[:properties][:events] = self.events.map do |event|
      {
        id: event.id,
        title: event.title,
        startdate: event.startdate,
        enddate: event.enddate,
        timescale: event.timescale
      }
    end

    geo_json_hash[:properties][:tags] = self.tags.map do |tag|
      tag.name
    end

    geo_json_hash

  end

end

