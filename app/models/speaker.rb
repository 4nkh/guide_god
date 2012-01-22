require 'espeak-ruby'
require 'digest/sha1'
require "net/http"
require "uri"
require "juggernaut"
class Speaker
  include ESpeak

  def self.get_response(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    return response.body if response.body
  end

  def self.refresh_data(origins, destinations, mode, language, sensor="false", voice, gender, speed, pitch)
    uri = URI.parse("http://maps.googleapis.com/maps/api/distancematrix/json?origins=#{origins}&destinations=#{destinations}&mode=#{mode}&language=#{language}&sensor=#{sensor}")
    @speaker = Speaker.get_response(uri)
    @data = ActiveSupport::JSON.decode(@speaker)
    self.send_message(get_js(get_text(@data), voice, gender, speed, pitch)) if @data['status'] == "OK"
  end
private
  
  def self.send_message(message)
    Juggernaut.publish("public", message)
  end

  def self.get_js(text, voice, gender, speed, pitch)
    "<script>voice_output('#{text}', '#{pitch}', '#{voice}', '#{gender}', '#{speed}');</script>"
  end
  
  def self.get_text(data)
    @distance = data['rows'][0]['elements'][0]['duration']['text']
    puts @distance
    unless @distance == "2 minutes" || @distance == "1 minute"
      "#{'votre taxi est presentement a '}#{(data['rows'][0]['elements'][0]['distance']['text']).gsub('km','kilomeitre')}#{' soit a environ '}#{data['rows'][0]['elements'][0]['duration']['text']}#{' de votre position'}"
    else
      "votre taxi est presentement arriver a destination hou sur le point de leitre"
    end
  end
end
