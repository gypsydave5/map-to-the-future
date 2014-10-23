require 'json'

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
        new_event = Event.create(event)
        new_event.reciprocate_event_links
      end
    end

    def import_property(feature, property, event)
      if property =~ /date/
        import_date_property(feature, property, event)
      elsif property == "tags"
        import_tag(feature, property, event)
      elsif property == "events"
        import_linked_events(feature, property, event)
      elsif property == "links"
        import_links(feature, property, event)
      else
        event[property.to_sym] = feature["properties"][property]
      end
    end

    def import_date_property(feature, property, event)
      event[property.to_sym] = DateTime.iso8601(feature["properties"][property].to_s)
    end

    def import_tag(feature, property, event)
      event[property.to_sym] = feature["properties"][property].map do |tag|
        Tag.first_or_create(name: tag)
      end
    end

    def import_linked_events(feature, linked_events, event)
      event[linked_events.to_sym] =
        feature["properties"][linked_events].map do |linked_event_title|
          Event.first(title: linked_event_title)
        end
    end

    def import_links(feature, links, event)
      event[links.to_sym] =
        feature["properties"][links].map do |link|
          Link.create(name: link["name"], url: link["url"])
        end
    end


    def fetch_relevant_events(year)
      all({
        :startdate.gte => DateTime.new(year.to_i),
        :startdate.lt => DateTime.new(year.to_i + 1)
      })
    end

  end

  def link_string
    "<a data-year='#{self.startdate.year}' data-id='#{self.id}' class='linked-event'>#{self.title}</a>"
  end

  def export_geojson
    to_geojson_feature.to_json
  end

  def to_geojson_feature
    hash = construct_geo_json_hash(self)
    insert_linked_events(self.events, hash)
    insert_tags(self.tags, hash)
    insert_links(self.links, hash)
    hash
  end

  def construct_geo_json_hash(event)
    {
      type: "Feature",
      properties: {
        id: event.id,
        title: event.title,
        short_description: event.short_description,
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

  def insert_links(links, geo_json_hash)
    geo_json_hash[:properties][:links] = links.map do |link|
      {
        name: link.name,
        url: link.url,
        link: "<a href='#{link.url}' target='_blank'>#{link.name}</a>"
      }
    end
  end

  def insert_linked_events(linked_events, geo_json_hash)
    geo_json_hash[:properties][:events] = linked_events.map do |event|
      {
        id: event.id,
        title: event.title,
        startdate: event.startdate,
        enddate: event.enddate,
        timescale: event.timescale,
        link: event.link_string
      }
    end
  end

  def reciprocate_event_links
    self.events.each do |linked_event|
      linked_event.events << self
      linked_event.save
    end
  end
end
