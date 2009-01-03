module EventsHelper  
  
  def format_date(date, use_time = false)
    unless date.nil?
      if use_time == true
        ampm = date.strftime("%p").downcase
        new_date = date.strftime("%B %d, %Y at %I:%M" + ampm)
      else      
        new_date = date.strftime("%m/%d/%Y")
      end
    end
  end
  
  def draw_map(map, width, height)
    return map.to_html, map.div(:width => width, :height => height)     
  end
	
	def if_old(date)
		unless date.nil?
			if date < Date.today
				return :expired.to_s
			else
				return :fresh.to_s
			end
		end
	end
   
end
