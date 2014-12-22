require 'json'
require 'open-uri'
require_relative 'companies.rb'

output_file = File.open("output.csv", "a")
root = 'http://api.crunchbase.com/v/2/organization/'
API_KEY = 'ENTER_YOUR_CRUNCHBASE_AUTH_KEY'

COMPANIES.each_with_index do |name, i|
	url = root + name + '/offices?user_key=' + API_KEY

	#load api doc, parse for address info
	#grab address keys and vals, output as string
	begin
		doc = JSON.load(open(url))
		address_hash = doc['data']['items'].first
		keys = ['street_1', 'street_2', 'city', 'postal_code']
		vals = keys.map{|key| address_hash[key] }
		
		val1 = vals[1] ? ' ' + vals[1] : ''
		address = vals[0] + val1 + ', ' + vals[2] + ' CA ' + vals[3]
	rescue 
	end

	# To get around Crunchbase's 50 request per minute limitation
  sleep(2)

	output_file.puts
	output_file.write "#{name}, #{address}"
	puts "finished company #{name}, ##{i}, at #{Time.now.strftime("%H:%M")}"
end

