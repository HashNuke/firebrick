app.filter "relativeTime", ->
  (text)->
    time = moment(text)
    if (moment().unix() - time.unix()) > 86400
      time.format("MMM D, YYYY")
    else
      time.fromNow()
