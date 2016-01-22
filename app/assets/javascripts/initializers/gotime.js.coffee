window.GOTIME_SYNCED = false
GoTime.setOptions(
  AjaxURL: '/slate/now',
  SyncInitialTimeouts: [0, 1000, 2000, 4000, 8000],
  SyncInterval: 10000,
  WhenSynced: (time, method, offset, precision) ->
    window.GOTIME_SYNCED = true
    console.log('synced')
)
