require 'slack-ruby-client'
require 'galerts'

# overide hash-keys to become methods for cleaner calls
class Hash
  def method_missing(m)
    key = m.to_s
    return self[key] if self.has_key? key
    super
  end
end

## Initial load and setup
def init
  
  # Setup Slack
  Slack.configure do |config|
    config.token = ENV['SLACK_TOKEN']
    if not config.token
      puts('Missing ENV[SLACK_TOKEN]! Exiting program')
      exit
    end
  end
  @client = Slack::RealTime::Client.new
  @client.on :hello do
     puts("Connected '#{@client.self['name']}' to '#{@client.team['name']}' team at https://#{@client.team['domain']}.slack.com.")
  end

  # Setup GA
  @GA_manager = Galerts::Manager.new(ENV['GMAIL_USER'], ENV['GMAIL_PASS'])
  @alert_cache = @GA_manager.alerts
  
  # Setup message hooks
  setupMessageHook()

  # Cleanup hooks
  @client.on :close do |_data|
    puts 'Connection closing, exiting.'
    EM.stop
  end
  @client.on :closed do |_data|
    puts 'Connection has been disconnected.'
  end

  # Run this bad boy
  @client.start!
  
end

# Message hook 
def setupMessageHook
  @client.on :message do |data|
    puts data
    resp = handleMessage(data)
    @client.message channel: data.channel, text: resp if resp
  end
end

# Parse a message, and return the text for response
def handleMessage( data )
  case data.text
    
  #------- MISC -------------------------------------------  
  when 'bot hi' then
    return "Hi <@#{data.user}> 🙌\n"
  when 'bot dance' then
    return "👯👯👯👯👯👯"
    
    
   #------- ADD -------------------------------------------
   when /^bot add / then
     c = data.text.slice(8..-1)
     return false if c == ""
     
     if @alert_cache.find { |a| a.query == c }
       return "I'm already tracking #{c} 😚"
     end 
     
     new_alert = @GA_manager.create(c, {
       :frequency => Galerts::RT,
       :language => "en",
       :sources => [Galerts::NEWS],
       :how_many => Galerts::BEST_RESULTS,
       :delivery => Galerts::EMAIL
       }
     )
     if new_alert
       @alert_cache << new_alert
       return "Ok, tracking #{c} 🙏"
     else
       return "Sorry, something went wrong 😱"
     end
      
      
   #------- REMOVE ----------------------------------------
   when /^bot remove / then
     c = data.text.slice(11..-1)
     return false if c == ""
     
     a = @alert_cache.find { |a| a.query == c }
     return "I'm not tracking #{c} 😁" if !a
     
     @alert_cache.delete( a )
     @GA_manager.delete( a )
     return "Ok, removing #{c} 🙏"
     
  
   #------- LIST ------------------------------------------       
   when /^bot list/ then
     return "Currently tracking:\n" + @alert_cache.collect(&:query).join("\n")
    
  #------- ELSE -------------------------------------------       
   when /^bot/ then
     return "Try something like: \
             \n*bot add* doordash \n*bot remove* doordash \n*bot list* \n*bot hi*"

   #------- END ----------------------------------------
   end
end

init