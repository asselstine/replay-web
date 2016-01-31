class Slate extends ComponentBase
  name: 'slate'
  constructor: (el) ->
    super
    @$el.addClass('not-synced')
    @$date = @$el.find('.date')
    @$time = @$el.find('.time')
    @$seconds = @$el.find('.seconds')
    @interval = window.setInterval( ()=>
      @$el.removeClass('not-synced') if window.GOTIME_SYNCED
      mom = moment(new GoTime())
      date = mom.format('MMM D YYYY Z')
      time = mom.format('HH:mm')
      seconds = mom.format('ss.SSS')
      @$date.html(date)
      @$time.html(time)
      @$seconds.html(seconds)
    , 100)

window.Slate = Slate
