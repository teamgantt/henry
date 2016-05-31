# Description
#   A hubot script that deploys TeamGantt's marketing site via ansible
#
# Dependencies:
#   hubot-ansible-me
#
# Commands:
#   hubot deploy <ref/branch> to <server> - deploys the branch to the appropriate host
#
# Author:
#   Jake Buob <jake@teamgantt.com>

module.exports = (robot) ->
  robot.respond /deploy (.*) to (.*)/i, (msg) ->
    command = "meta.yml -i hosts -e 'server=#{msg.match[2]} deploy_ref=#{msg.match[1]}'"

    robot.emit 'ansible:runPlaybook', msg, command
