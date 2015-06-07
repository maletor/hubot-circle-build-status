# Description:
#   CircleCI notifier that listens for payloads at /circleci-notify and notifies proper Campfire room.
#
# Dependencies:
#   moment
#   moment-duration-format
#
# Configuration:
#   HUBOT_DANGER_ZONE_ROOM
#   HUBOT_SITUATION_ROOM
#
# Commands:
#   None
#
# Notes:
#   req.body.payload response looks like this: https://circleci.com/docs/api#build
#
# Author:
#   sarkis
#
moment = require("moment")
require("moment-duration-format")

module.exports = (robot) ->
  robot.router.post '/circleci-notify', (req, res) ->
    pl = req.body.payload
    room = if pl.branch == "master" then process.env.HUBOT_DANGER_ZONE_ROOM else process.env.HUBOT_SITUATION_ROOM
    duration = moment.duration(pl.build_time_millis, "ms").format("mm:ss", { trim: false })
    message = "#{pl.status.toUpperCase()}: #{pl.committer_name}'s build ##{pl.build_num} in #{pl.reponame}/#{pl.branch} completed in #{duration} -- #{pl.build_url}"

    # only notify of FIXED and FAILED
    if pl.status != 'success'
      robot.messageRoom room, message

    res.send 'OK'
