import _ from 'lodash'

export default function (time, latLngs, timestamps) {
  _.find(timestamps, (timestamp) => {
    return timestamp > time
  })
}
