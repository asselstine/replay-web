class KMLOutput
  include Virtus.model

  attribute :user_evaluator, UserEvaluator

  def call
    kfile = KMLFile.new
    folder = KML::Folder.new(name: 'foo')
    coords.each do |coord|
      folder.features << KML::Placemark.new(
        name: "#{coord[0]}",
        geometry: { lat: coord[1][0], lng: coord[1][1] }
      )
    end
    kfile.objects << folder
    kfile.render
  end

  protected

  def coords
    result = []
    context = user_evaluator.context
    while true
      result << [ context.start_at, user_evaluator.coords ]
      break unless context.next!
    end
    result
  end
end
