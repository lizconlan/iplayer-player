require 'sinatra'
require 'haml'

load 'lib/programme_list.rb'

enable :sessions

get "/" do
  #Hmmm, maybe this could be in a dropdown box
  data_feed = "http://feeds.bbc.co.uk/iplayer/cbeebies/list"
  
  #fetch a list of currently available stuff
  #(let's assume it's available if it's in the RSS feed)
  @programmes = ProgrammeList.new(data_feed)
  
  played = session[:played] ? session[:played] : []
  
  #bit clumsy but it'll do for now
  @programmes.delete_if { |x| played.include?(x) }
  
  #ok, now getting very clumsy but this is slightly unlikely with this feed
  #also it's past midnight and my brain's turned into a pumpkin
  if @programmes == []
    @programmes = ProgrammeList.new(data_feed)
    session[:played] = []
  end
  
  #pick a random programme
  @now_playing = rand(@programmes.size)
  
  haml :index
end