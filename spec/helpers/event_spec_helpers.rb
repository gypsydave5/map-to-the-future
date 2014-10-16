module EventSpecHelpers

  def features_response(array)
    feature_array = array.map {|feature_hash| feature_json(feature_hash)}
    {
      type: "FeatureCollection",
      features: feature_array
    }
  end

  def feature_json(event)
        {
            type: "Feature",
          properties: {
              id: 4,
              title: event[:title],
              description: event[:description],
              startdate: event[:startdate],
              enddate: event[:enddate],
              timescale: event[:timescale],
              events: [],
              tags: event.tags.map(&:name)
            },
          geometry: event[:geometry]
        }
  end

  def point_event(name, description, tags, start_date, end_date, timescale, coords)
    Event.create({title: name,
                  description: description,
                  tags: tags.map{|tag| Tag.first_or_create(name: tag)},
                  startdate: DateTime.new(start_date),
                  enddate: DateTime.new(end_date),
                  geometry: { type: "Point", coordinates: coords }})
  end

  def line_event(name, description, tags, start_date, end_date, timescale, coords)
    Event.create({title: name, description: description, tags: tags, startdate: DateTime.new(start_date), enddate: DateTime.new(end_date), geometry: { type: "LineString", coordinates: coords }})
  end

  def polygon_event(name, description, tags, start_date, end_date, timescale, coords)
    Event.create({title: name, description: description, tags: tags, date: DateTime.new(start_date), enddate: DateTime.new(end_date), geometry: { type: "Polygon", coordinates: coords }})
  end

end
