require 'nokogiri'
require 'rest_client'

class ProgrammeList < Array  
  def self.new(data_feed)
    #make sure we get a valid iPlayer RSS link
    return [] unless data_feed[0..29] == "http://feeds.bbc.co.uk/iplayer"
        
    begin
      data = RestClient.get(data_feed)
    rescue
      return []
    end
        
    programmes = []
  
    doc = Nokogiri::XML(data)
    
    doc.search('entry').each do |entry|
      title = entry.search("title").text
      href = entry.search("link").attr("href").value
      code = href.gsub("http://www.bbc.co.uk/iplayer/episode/", "")
      code = code[0..code.index("/")-1]
      programmes << {'title' => title, 'link' => href, 'code' => code}
    end
    
    return programmes
  end
end