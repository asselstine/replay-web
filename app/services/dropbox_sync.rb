require 'dropbox_sdk'

class DropboxSync

  def synchronize(dropbox_event)
    client = DropboxClient.new( dropbox_event.user.access_token )
    next_delta = true
    while next_delta
      delta  = client.delta(dropbox_event.cursor, dropbox_event.path)
      process_delta(dropbox_event, delta)
      next_delta = delta['has_more']
    end
  end

  def process_delta(dropbox_event, delta)
    if dropbox_event.cursor != delta['cursor']
      if delta['reset']
        dropbox_event.dropbox_photos.destroy_all
      end
      delta['entries'].each do |entry|
        process_delta_entry(entry)
      end
      dropbox_event.cursor = delta['cursor']
    end
  end

  def process_delta_entry(entry)
    path = entry[0]
    metadata = entry[1]
    photo = dropbox_event.dropbox_photos.find_by_path(path)
    if !metadata
      Rollbar.debug("Destroying photo with path #{path}")
      photo.destroy if photo.present?
    elsif /\.((jpg)|(jpeg)|(png))$/ =~ path #is a photo
      contents, contents_metadata = client.get_file_and_metadata(path, metadata['rev'])
      tmp = Tempfile.new 'image'
      begin
        tmp.binmode
        tmp.write contents
      ensure
        tmp.close
        tmp.unlink
      end
      if photo
        if photo.rev != metadata['rev'] #need to update
          photo.photo = tmp
          photo.rev = metadata['rev']
          photo.save
        end
      else
        photo = DropboxPhoto.create(:path => path, :rev => metadata['rev'], :dropbox_event => dropbox_event)
        photo.photo = tmp
        photo.save
      end
    end
  end

end
