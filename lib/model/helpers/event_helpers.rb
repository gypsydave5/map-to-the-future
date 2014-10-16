module EventHelpers

  def self.included(base)
    base.extend(EventClassHelpers)
  end

  module EventClassHelpers

    def add_geojson_events(geojson)
      upload = JSON.parse(geojson)
      upload["features"].each do |feature|
        event = { geometry: feature["geometry"] }
        feature["properties"].keys.each do |property|
          import_property(feature, property, event)
        end
        Event.create(event)
      end
    end

    def import_date_property(feature, property, event)
      event[property.to_sym] = DateTime.new(feature["properties"][property].to_i)
    end

    def import_tag(feature, property, event)
      event[property.to_sym] = feature["properties"][property].map do |tag|
        Tag.first_or_create(name: tag)
      end
    end

    def import_linked_events(feature, linked_events, event)
      event[linked_events.to_sym] =
        feature["properties"][linked_events].map do |linked_event|
          Event.get(linked_event["id"].to_i)
        end
    end

    def import_property(feature, property, event)
      if property =~ /date/
        import_date_property(feature, property, event)
      elsif property == "tags"
        import_tag(feature, property, event)
      elsif property == "events"
        import_linked_events(feature, property, event)
      else
        event[property.to_sym] = feature["properties"][property]
      end
    end

    def fetch_relevant_events(year)
      all({
        :startdate.gte => DateTime.new(year.to_i),
        :startdate.lt => DateTime.new(year.to_i + 1)
      })
    end
  end

  def export_geojson
    to_geojson_feature.to_json
  end

  def to_geojson_feature
    hash = construct_geo_json_hash(self)
    insert_linked_events(self.events, hash)
    insert_tags(self.tags, hash)
    hash
  end

  def construct_geo_json_hash(event)
    {
      type: "Feature",
      properties: {
        id: event.id,
        title: event.title,
        description: event.description,
        startdate: event.startdate,
        enddate: event.enddate,
        timescale: event.timescale
      },
      geometry: event.geometry
    }
  end

  def insert_tags(tags, geo_json_hash)
    geo_json_hash[:properties][:tags] = tags.map do |tag|
      tag.name
    end
  end

  def insert_linked_events(linked_events, geo_json_hash)
    geo_json_hash[:properties][:events] = linked_events.map do |event|
      {
        id: event.id,
        title: event.title,
        startdate: event.startdate,
        enddate: event.enddate,
        timescale: event.timescale
      }
    end
  end



end
