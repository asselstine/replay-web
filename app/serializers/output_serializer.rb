class OutputSerializer < ApplicationSerializer
  attributes :signed_url,
             :container_format,
             :thumbnail_urls
end
