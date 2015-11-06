# Description:
#   CircleCI notifier that listens for payloads at /circleci-notify and notifies proper Slack channel.
#
# Dependencies:
#   moment
#   moment-duration-format
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Notes:
#   req.body.payload response looks like this: https://circleci.com/docs/api#build
#
# Author:
#   sarkis
#   maletor
#   mattpickle

moment = require("moment")
require("moment-duration-format")

module.exports = (robot) ->
  robot.router.post '/circleci-notify', (req, res) ->
    pl = req.body.payload
    room = if pl.branch == "master" then '#engineering' else '#notifications'
    duration = moment.duration(pl.build_time_millis, "ms").format("mm:ss", { trim: false })
    message = "#{pl.status.toUpperCase()}: #{pl.committer_name}'s build ##{pl.build_num} in #{pl.reponame}/#{pl.branch} completed in #{duration} -- #{pl.build_url}"

    # only notify of FIXED and FAILED
    if pl.status != 'success'
      robot.messageRoom room, message

    res.send 'OK'
