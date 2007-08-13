class ChainController < ApplicationController
  
  #in_place_edit_for :chain, :name
  
  def index
    @year = 2007
    @month = 7
    session[:chain] = Chain.find_by_key(params[:key]) if params[:key]
    session[:chain] ||= Chain.new
    session[:chain].name ||= "Click Here to Rename Your Seinfeldian Chain"
    session[:chain].tz ||= TZInfo::Timezone.get("UTC")
    session[:chain].reload unless session[:chain].new_record?
    @chain = session[:chain]
  end
  
  def update_chain
    date = Date.parse(params[:id])

    chain_is_new = session[:chain].new_record?
    should_add_day = true
    if chain_is_new
      session[:chain].days.each do |day|
        if date == day.when
          should_add_day = false
        end
      end
    else
      should_add_day = false if session[:chain].days.find_by_when(date)
    end

    if should_add_day
      @added = true
      session[:chain].days << [Day.new(:when => date)]
    else
      @added = false
      if session[:chain].new_record?
        session[:chain].days.delete_if { |day| day.when == date }
      else
        session[:chain].days.find_by_when(date).destroy
      end
    end
  end

  def save
    session[:chain].save
    redirect_to :action => :index, :key => session[:chain].key
  end
  
  def new_chain
    session[:chain] = nil
    flash[:notice] = "Welcome to your new chain" 
    redirect_to :action => :index
  end
  
  def get_chain_name
    render :partial => "chain_name"
  end
  
  def set_chain_name
    session[:chain].name = params[:value]
    session[:chain].save unless session[:chain].new_record?
    render :partial => "chain_name"
  end
  
  def set_time_zone
    session[:chain].tz = TZInfo::Timezone.get(params[:chain][:time_zone])
    session[:chain].save unless session[:chain].new_record?
    redirect_to :action => :index
  end

end
