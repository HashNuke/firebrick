app.filter "relativeTime", ->
  (text)->
    time = moment(text)
    difference = moment().unix() - time.unix()
    if difference > 31536000
      time.format("MMM D, YYYY")
    else if difference > 86400
      time.format("MMM D")
    else
      time.fromNow()
