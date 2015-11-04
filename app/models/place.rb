class Place < ActiveRecord::Base
	geocoded_by :name   # can also be an IP address
	after_validation :geocode          # auto-fetch coordinates	

	def iso3
		return Country.find_country_by_name(self.name).alpha3
	end
	
	def iso2
		return Country.find_country_by_name(self.name).alpha2
	end
	
	def rainData
		return @rainInfo = HTTParty.get("http://climatedataapi.worldbank.org/climateweb/rest/v1/country/mavg/pr/1980/1999/" + self.iso3.to_s)
	end		

	def tempData
		return @tempInfo = HTTParty.get("http://climatedataapi.worldbank.org/climateweb/rest/v1/country/mavg/tas/1980/1999/" + self.iso3.to_s)
	end		

	def capCity
		c = HTTParty.get("http://api.worldbank.org/countries/" + self.iso3.to_s + "/?format=json")
		return @capCity = c[1][0]['capitalCity']
	end

	def countryGeo
		return @co = GeoNamesAPI::Country.find(self.iso2)
	end

	def population
		@pop = self.countryGeo
		return @p = @pop.population
	end

	def currWeather
		lon = self.longitude
		lat = self.latitude
		getLoc = GeoNamesAPI::Country.find(self.iso2)

		north = getLoc.north.to_s
		south = getLoc.south.to_s
		east = getLoc.east.to_s
		west = getLoc.west.to_s
		@currWeather = HTTParty.get("http://api.geonames.org/weatherJSON?north="+north+"&south="+south+"&east="+east+"&west="+west+"&username=hathbanger")
		return @currWeather['weatherObservations']
	end


	def temp
		@temp = self.currWeather.first['temperature']
		
		return @t = (@temp.to_i * 9/5) + 32
	end

	def dew
		@dew = self.currWeather.first['dewPoint']
		
		return d = (@dew.to_i * 9/5) + 32
	end

	def humidity
		@hum = self.currWeather.first['humidity']
		
	end

	def windDir
		@windDirection = self.currWeather.first['windDirection']
		
	end

	def windSpeed
		@windSpeed = self.currWeather.first['windSpeed']
		
	end


	def forcastAndConditions
		@fnc = @w_api
		return @fnc
	end
end
