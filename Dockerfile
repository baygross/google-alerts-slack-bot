FROM ruby:2.3-onbuild
WORKDIR /app
COPY app/ .
CMD ruby bot.rb