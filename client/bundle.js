// Exposes React for react_ujs
require('expose?React!react')
require('expose?ReactDOM!react-dom')
require('react-select/dist/react-select.css')

require('expose?Drafts!./components/drafts')
require('expose?Slate!./components/slate')
require('expose?Uploads!./components/uploads')
require('expose?VideoPlayer!./components/video-player')
require('expose?SetupMap!./components/setup-map')
require('expose?ViewSetup!./components/view-setup')
require('expose?UploadEditor!./components/upload-editor')
