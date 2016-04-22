class KMLOutput
  include Virtus.model

  attribute :user_evaluator, UserEvaluator

  def call  
    kml = KMLFile.new
    folder = KML::Folder.new(name: 'Route')
    coordinates.each do |coordinate|
      folder.features << KML::Placemark.new(
        name: coordinate[0], 
        geometry: KML::Point.new(coordinates: { lat: coordinate[1][0],
                                                lng: coordinate[1][1]})
      )
    end
    kml.objects << folder
    kml.render
  end

  protected

  def coordinates
    coords = []
    context = user_evaluator.context
    while true
      coords << [context.start_at, user_evaluator.coords]
      break unless context.next!
    end
    coords
  end

end
