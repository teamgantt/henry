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

usersWithProductionDeployPrivileges = process.env.USERS_WITH_PRODUCTION_DEPLOY_PRIVILEGES.split(',')

module.exports = (robot) ->
  robot.respond /deploy (.*) to (.*)/i, (msg) ->
    ref = msg.match[1]
    server = msg.match[2]
    user = msg.message.user.name.toLowerCase()
    command = "meta.yml -i hosts -e 'server=#{server} deploy_ref=#{ref}'"
    canDeployProduction = usersWithProductionDeployPrivileges.indexOf(user) > -1

    if server == 'production' && !canDeployProduction
      prettyPrivilegedUserList = usersWithProductionDeployPrivileges.join(', ')
      msg.send "Sorry, only the following users can deploy to production: #{prettyPrivilegedUserList}"
    else
      msg.send ":shipit::shipit::shipit:  Deploying #{ref} to Production  :rocket::rocket::rocket:" if server == 'production'
      robot.emit 'ansible:runPlaybook', msg, command
