Modal = require('react-modal')
ModalStyle = require('../util/modal-default-style')
Select = require('react-select')

module.exports = React.createClass
  displayName: 'PhotoUploadModal'

  propTypes:
    upload: React.PropTypes.object.isRequired
    isOpen: React.PropTypes.bool.isRequired
    onRequestClose: React.PropTypes.func.isRequired

  render: ->
    <Modal className='edit-upload-modal modal-dialog modal-lg'
           style={ModalStyle}
           isOpen={@props.isOpen}
           onRequestClose={@props.onRequestClose}>

      <div className='modal-content'>
        <div className='modal-header'>
          <h3>{@props.upload.filename}</h3>
        </div>
        <div className='modal-body'>
          <img className='tile__img' src={@props.upload.photo.url}/>
        </div>
        <div className='modal-footer'>
          <div className='pull-right'>
            <a href='javascript:;' className='btn btn-default' onClick={@props.onRequestClose}>Close</a>
          </div>
        </div>
      </div>
    </Modal>
