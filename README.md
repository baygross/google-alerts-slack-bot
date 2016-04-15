## Overview
Here lives a slackbot to control google-alerts!

The goal was to integrate with the /feed functionality in Slack native, but that got confusing so for now we just subscribe by email.

Usage:
  bot hi
  bot add oscar health
  bot remove oscar health
  bot list


### Assumptions
* You have signed up with [Beep Boop](https://beepboophq.com)
* You have a fork of this bot on GitHub, linked into Beep Boop

* You have a slackbot API key, see [here](https://my.slack.com/services/new/bot)
* You have Docker installed locally, see [here](https://docs.docker.com/mac/)
* You have a Google account w/o 2-factor you can use for Google Alerts.

### Background Reading
[Beep Boop](https://beepboophq.com/docs/article/overview)
[Slack API documentation](https://api.slack.com/).
@dblock's excellent [ruby slackbot](https://github.com/dblock) framework 


### Run locally in Docker
	docker build -t ga-slackbot .
	docker run --rm -it -e SLACK_TOKEN={KEY} GMAIL_USER={UNAME} GMAIL_PASS={PASS} ga-slackbot
  
  
### Run in BeepBoop
If you have linked your local repo with the Beep Boop service (check [here](https://beepboophq.com/0_o/my-projects)), changes pushed to the remote master branch will automatically deploy.


#### Misc Docker Commands
// add this to .bash_profile so each shell can talk to daemon VM
  eval "$(docker-machine env default)"

// check if daemon is running
  docker-machine ls

// run daemon if not
  docker-machine create --driver virtualbox default

// status
  docker images
  docker ps -a 

// stop and delete all containers
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)

// mount with volume for live code development
  docker run --rm -it -e SLACK_TOKEN={KEY} GMAIL_USER={UNAME} GMAIL_PASS={PASS} -v {PWD_ABSOLUTE_PATH/app}:/app ga-bot