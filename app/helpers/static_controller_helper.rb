module StaticControllerHelper
	
	def format_time(time)
		/(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2})/.match(time.to_s)
		$1+"T"+$2
	end

end
