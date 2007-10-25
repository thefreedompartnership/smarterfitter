class ChainController < ApplicationController
  
  def index
    @date = Date.today
    if params[:year] and params[:year].to_i != 0
      @year = params[:year].to_i
    else
      @year = @date.year
    end
    if params[:month] and params[:month].to_i != 0
      @month = params[:month].to_i
    else
      @month = @date.month
    end
    
    @next = Date.civil(@year, @month, 1) >> 1
    @previous = Date.civil(@year, @month, 1) << 1
    
    session[:chain] = Chain.find_by_key(params[:key]) if params[:key]
    session[:chain] ||= Chain.new
    session[:chain].name ||= "Click Here to Rename Your Seinfeldian Chain"
    session[:chain].tz ||= TZInfo::Timezone.get("UTC")
    session[:chain].reload unless session[:chain].new_record?
    @chain = session[:chain]
  end
  
  def update_chain
    # there's a problem here that happens when the chain isn't in the
    # session any longer... should find some way to fix this
    # it looks like it is the googlebot that causes this problem
    # grrr... still, really should do something about it
    date = Date.parse(params[:id])
    @chain = session[:chain]
    @added = @chain.update_day(date)
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
    @chain = session[:chain]
    render :partial => "chain_name"
  end
  
  def set_chain_name
    @chain = session[:chain]
    @chain.name = params[:value]
    @chain.save unless @chain.new_record?
  end
  
  def set_time_zone
    @chain = session[:chain]
    @chain.tz = TZInfo::Timezone.get(params[:chain][:time_zone])
    @chain.save unless session[:chain].new_record?
    redirect_to :action => :index
  end

  def view
    @chain = Chain.find_by_read_key(params[:read_key])
  end

end
