require 'slack-ruby-client'

# hash keys become methods for cleaner calls
class Hash
  def method_missing(m)
    key = m.to_s
    return self[key] if self.has_key? key
    super
  end
end

# Setup slack from dblock code
Slack.configure do |config|
  config.token = ENV['SLACK_TOKEN']
  if not config.token
    puts('Missing ENV[SLACK_TOKEN]! Exiting program')
    exit
  end
end

# init
client = Slack::RealTime::Client.new
client.on :hello do
   puts("Connected '#{client.self['name']}' to '#{client.team['name']}' team at https://#{client.team['domain']}.slack.com.")
end


#######################################################################
#
# Main message logic
# 
@alert_list = []

# hoook
client.on :message do |data|
  puts data
  resp = handleMessage(data)
  client.message channel: data.channel, text: resp if resp
end

# parse and route
def handleMessage( data )
  case data.text
  when 'bot hi' then
     
   # ADD
   when /^bot add / then
     c = data.text.slice(8..-1)
     return false if c == ""
     
     if @alert_list.include?(c)
       return "I'm already tracking #{c}"
     end 
     
     @alert_list << c
     return "Ok, tracking #{c}"
      
   # REMOVE    
   when /^bot remove / then
     c = data.text.slice(11..-1)
     return false if c == ""
     
     if !@alert_list.include?(c)
       return "I'm not tracking #{c}"
     end 
     
     @alert_list.delete(c)
     return "Ok, removing #{c}"
     
  
   # List          
   when /^bot list/ then
     return "Currently tracking:\n" + @alert_list.join("\n")
    
   # ELSE         
   when /^bot/ then
     return "Try something like: \
             \n*bot add* doordash \n*bot remove* doordash \n*bot list* \n*bot hi*"

   end
end


#######################################################################

# Clean up
client.on :close do |_data|
  puts 'Connection closing, exiting.'
  EM.stop
end
client.on :closed do |_data|
  puts 'Connection has been disconnected.'
end


# Do it
client.start!