module ChainHelper
  def draw_calendar
    calendar({:year => @year, :month => @month, :show_today => false}) do |d|
		  cell_text = "#{d.mday}<br />"
		  cell_attrs = {:class => 'day', :id => d.to_s, 
			:onclick => remote_function(:url => {:action => 'update_chain', :id => d.to_s})
			}
		  cell_attrs[:class] = "#{cell_attrs[:class]} today" if d == session[:chain].tz.utc_to_local(Time.now).to_date
		  cell_attrs[:class] =  "#{cell_attrs[:class]} specialDay" if session[:chain].days.detect {|day| day.when == d}
		  [cell_text, cell_attrs]
		end		
  end
  
  def draw_chain_history
    
    if @chain.days.size == 0
      first_day = Date.civil(@year, @month, 1)
  		last_day  = Date.civil(@year, @month, -1)
    else
      first_day = [Date.civil(@year, @month, 1), Date.civil(@chain.first_day.year, @chain.first_day.month, 1)].min
      last_day = [Date.civil(@year, @month, -1), Date.civil(@chain.last_day.year, @chain.last_day.month, -1)].max
    end

    
		current_year = nil
		current_month = nil
		history = '<table id="chain_history">'
		first_day.upto(last_day) do |day|
			if current_year != day.year
				current_year = day.year
				new_year = true
			else
				new_year = false
			end
			if current_month != day.month
				current_month = day.month
				new_month = true
			else
				new_month = false
			end
			history << "<tr><th colspan='2'>#{day.year}</th></tr>" if new_year
  		if new_month
  			history << "</td></tr>" unless first_day.year == day.year and first_day.month == day.month
  			history << "<tr><td class='month'>#{Date::MONTHNAMES[day.month]}</td><td>"
  		end
			if @chain.has_day?(day)
				history << image_tag("chain/small_cross.png", :id => "small_#{day}")
			else
				history << image_tag("chain/small_box.png", :id => "small_#{day}")
			end
			history << " "
  	end
  	history << "</td></tr></table>"
  end
end
