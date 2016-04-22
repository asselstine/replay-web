class KMLOutput
  include Virtus.model

  # def call
  #   kfile = KMLFile.new
  #   folder = KML::Folder.new(name: 'foo')
  #   coords.each do |coord|
  #     folder.features << KML::Placemark.new(
  #       name: "#{coord[0]}",
  #       geometry: { lat: coord[1][0], lng: coord[1][1] }
  #     )
  #   end
  #   kfile.objects << folder
  #   kfile.render
  # end
end
