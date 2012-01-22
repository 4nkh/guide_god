class GmapsController < ApplicationController  
  
  def gmapframe
     @geo = Taxi.get_geotaxi(params)
     @home = GEO_HOME
  end
end
