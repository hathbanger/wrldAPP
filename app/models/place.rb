class Place < ActiveRecord::Base
	geocoded_by :name   # can also be an IP address
	after_validation :geocode          # auto-fetch coordinates	

	def iso3
		return Country.find_country_by_name(self.name).alpha3
	end
	
	def rainData
		return @rainInfo = HTTParty.get("http://climatedataapi.worldbank.org/climateweb/rest/v1/country/mavg/pr/1980/1999/" + self.iso3.to_s)
	end		

	def tempData
		return @tempInfo = HTTParty.get("http://climatedataapi.worldbank.org/climateweb/rest/v1/country/mavg/tas/1980/1999/" + self.iso3.to_s)
	end		

	

end
