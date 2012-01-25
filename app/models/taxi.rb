#require 'redis'
#require 'yajl'
#require 'multi_json'
#require 'yaml'
#require 'memcached'
class Taxi
  
  def self.save_taxi(params)
    unless Rails.cache.exist?(params[:id])
      Rails.cache.write(params[:id], [params[:long].to_i, params[:lat].to_i, Time.now.to_i], :expires_in => 10.minutes)
    else
      Rails.cache.write(params[:id], [params[:long].to_i, params[:lat].to_i, Time.now.to_i], :expires_in => 10.minutes)
    end
  end
  
  def self.get_geotaxi(params)
    @taxi = Rails.cache.read(params[:id])
    return @taxi ? [@taxi[0], @taxi[1]] : nil 
  end
  
  def self.get_taxi(params)
    Rails.cache.read(params["id"])
  end
  # Setup Redis
  #REDIS = Redis.new(YAML.load_file "./config/redis.yml")
 
  # Reset Redis - FOR DEVELOPMENT USE
  #REDIS.flushall
   
  # Setup JSON
  #MultiJson.engine = :yajl
  
  #def get_taxi(number)
    #cache = REDIS.get(number)
    #response = MultiJson.decode(cache) if cache != nil
  #end 
  
  #def save_taxi(id, params)
    #REDIS.set(id, MultiJson.encode(params))
  #end   
end  
