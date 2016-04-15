## Overview
TODO: desc
TODO: commands and examples


### Assumptions
* You have signed up with [Beep Boop](https://beepboophq.com)
* You have a fork of this bot on GitHub, linked into Beep Boop

* You have a slackbot API key, see [here](https://my.slack.com/services/new/bot)
* You have Docker installed locally, see [here](https://docs.docker.com/mac/)


### Background Reading
[Beep Boop](https://beepboophq.com/docs/article/overview)
[Slack API documentation](https://api.slack.com/).
@dblock's excellent [ruby slackbot](https://github.com/dblock) framework 


### Run locally in Docker
	docker build -t galert-slackbot .
	docker run --rm -it -e SLACK_TOKEN=<YOUR SLACK API TOKEN> galert-slackbot
  
  
### Run in BeepBoop
If you have linked your local repo with the Beep Boop service (check [here](https://beepboophq.com/0_o/my-projects)), changes pushed to the remote master branch will automatically deploy.


#### Misc Docker Commands
// add this to .bash_profile so each shell can talk to daemon VM
eval "$(docker-machine env default)"

// check if daemon is running
docker-machine ls

// run daemon if not
docker-machine create --driver virtualbox default

// stop and delete containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

// mount with volume for live code
docker run --rm -it -e SLACK_TOKEN={KEY} -v /Users/baygross/desktop/google-alerts-slack-bot/app:/app ga-bot