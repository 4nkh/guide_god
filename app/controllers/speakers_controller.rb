require 'espeak-ruby'
require 'digest/sha1'
require "uri"
class SpeakersController < ApplicationController
  include ESpeak
  layout false
  def refresh
    @geo = Taxi.get_geotaxi(params)
    @home = GEO_HOME
    params[:mode] = "driving"
    params[:language] = "fr-FR"
    @voice = "fr"
    @gender = "en-f2"
    @pitch = "0"
    @speed = "80"
    Speaker.refresh_data((@home.to_s).gsub('[','').gsub(']','').gsub(' ', ''), (@geo.to_s).gsub('[','').gsub(']','').gsub(' ', ''), params[:mode], params[:language], "false", @voice, @gender, @speed, @pitch)
    respond_to do |format|
      format.js 
    end
  end  
  
  def output
    @geo = [45.5521137, -73.8966954]
    @home = [46.5521137, -73.1966954]
    filename = "tmp/#{Digest::SHA1.hexdigest(params.to_s)}.mp3"
    espeak(filename, params) # unless filename exists
    send_data(File.read(filename), :type => "audio/mpeg", :filename => filename, :disposition => "inline")
    #render :file => File.read(filename), :content_type => 'audio/mpeg', :encoding => nil
    #[200, {'Content-type' => 'audio/mpeg'}, File.read(filename)]
  end
private
#  def get_link(uri)
#    http = Net::HTTP.new(uri.host, uri.port)
#    request = Net::HTTP::Get.new(uri.request_uri)
#    response = http.request(request)
#    return Nokogiri::HTML(response.body) if response.body
#  end  
end  