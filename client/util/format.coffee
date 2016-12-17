module.exports = {
  date: (date) ->
    moment(date).format('MMM MM, GGGG HH:mm')

  elapsed: (milliseconds) ->
    seconds = parseInt((milliseconds / 1000) % 60)
    minutes = parseInt((milliseconds / (1000*60)) % 60)
    hours   = parseInt((milliseconds / (1000*60*60)) % 24)
    millis  = parseInt(milliseconds % 1000)
    '' + hours + ':' + @pad(minutes, 2) + ':' + @pad(seconds, 2) + '.' + @pad(millis, 3)

  pad: (n, width, z) ->
    z = z || '0'
    n = n + ''
    if (n.length >= width)
      return n
    else
      return new Array(width - n.length + 1).join(z) + n
}
