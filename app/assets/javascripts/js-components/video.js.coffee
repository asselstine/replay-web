class Video extends ComponentBase
  name: 'video'

  constructor: (el) ->
    super(el)
    @$video = @$el.find('video')
    @$timestamp = @$el.find('.currentTimeMs')
    @$form = @$el.find('form')
    @$inputDate = @$el.find('input[name="date"]')
    @$inputTimezone = @$el.find('input[name="timezone"]')
    @$inputTimestamp = @$el.find('input[name="timestamp"]')
    @setCurrentTime(0)
    @$video[0].addEventListener('timeupdate', (e) =>
      @setCurrentTime(e.target.currentTime)
    )
    @$form.on('submit', @handleFormSubmit.bind(@))

  setCurrentTime: (timeS) ->
    @$currentTime = timeS
    @$timestamp.html(timeS * 1000)

  handleFormSubmit: (e) ->
    e.preventDefault()
    dateString = @$inputDate.val() + " " + @$inputTimestamp.val() + @$inputTimezone.val()
    timestamp = moment(dateString)
    if timestamp.isValid()
      adjustedStartTime = timestamp.clone().subtract(@$currentTime*1000, 'ms')
      adjustedEndTime = adjustedStartTime.clone().add(@$video[0].duration*1000, 'ms')
      console.debug('Display time: ', timestamp.toISOString())
      console.debug('Video start time: ', adjustedStartTime.toISOString())
      console.debug('Video end time: ', adjustedEndTime.toISOString())
      $.ajax
        url: @$form.attr('action')
        method: 'PUT'
        data:
          video:
            start_at: adjustedStartTime.toISOString()
            end_at: adjustedEndTime.toISOString()
            duration_ms: @$video[0].duration * 1000
        success: (data, xhr, status) =>
          console.debug("Saved!")
        error: (xhr, status) =>
          console.error('Could not save: ', xhr)
    else
      console.debug('invalid date')


window.Video = Video
