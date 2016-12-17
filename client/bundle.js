// Exposes React for react_ujs
require('expose?React!react')
require('expose?ReactDOM!react-dom')
require('react-select/dist/react-select.css')

require('expose?Activities!./components/activities')
require('expose?Drafts!./components/drafts')
require('expose?DraftsMap!./components/drafts-map')
require('expose?ExploreVideoDraft!./components/explore-video-draft')
require('expose?MapBrowser!./components/map-browser')
require('expose?SetupMap!./components/setup-map')
require('expose?Slate!./components/slate')
require('expose?UploadEditor!./components/upload-editor')
require('expose?Uploads!./components/uploads')
require('expose?VideoDraft!./components/video-draft')
require('expose?VideoPlayer!./components/video-player')
require('expose?ViewSetup!./components/view-setup')

require('expose?VideoJS!./components/videojs')
