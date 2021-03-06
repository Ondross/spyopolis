class AgentsController < ApplicationController

  # GET /agents
  # GET /agents.xml
  def index
    @agents = Agent.all

	@agents.each do |agent|
	if agent.locked
		if Time.now.seconds_since_midnight - agent.locktime > 30
			agent.locked = false
			agent.save!
		end
	end
	end
	
    respond_to do |format|
	  format.json  { render :json => @agents }
      format.html # index.html.erb
      format.xml  { render :xml => @agents }
    end
  end

  # GET /agents/1
  # GET /agents/1.xml
  def show
    @agent = Agent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @agent }
	  format.json  { render :json => @agent }
    end
  end

  # GET /agents/new
  # GET /agents/new.xml
  def new
    @agent = Agent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @agent }
	  format.json  { render :json => @agent }
    end
  end

  # GET /agents/1/edit
  def edit
    @agent = Agent.find(params[:id])

  end

  # POST /agents
  # POST /agents.xml
  def create
    @agent = Agent.new(params[:agent])
	
	if Agent.all.length == 0 or Agent.all.length == 1
		@agent.carrier = true
	else
		@agent.carrier = false
	end
	
	if Agent.all.length % 2 == 1
		@agent.team = 0
	else
		@agent.team = 1
	end
	
	@agent.lat = 0
	@agent.long = 0
	@agent.locktime = 0
	@agent.data_count = 100
	
	
    respond_to do |format|
      if @agent.save
        format.html { redirect_to(:json, :notice => 'Agent was successfully updated.') }
        format.xml  { render :xml => @agent, :status => :created, :location => @agent }
		format.json  { render :json => @agent,  :status => :created, :location => @agent}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @agent.errors, :status => :unprocessable_entity }
		format.json  { render :json => @agent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /agents/1
  # PUT /agents/1.xml
  def update
    @agent = Agent.find(params[:id])

	# put EMP logic here to calculate     Don't lock carriers.
	# for all other Agents
	   # if locking, @other_agent.update_attributes( :locked => true )
	# for me:
	   # update_result = @me.update_attributes( params[:agent].merge( {:locked => true}) )
	# else update result is just update attributes (params[:agent])	
	
	update_result = @agent.update_attributes(params[:agent])

	if @agent.locked
		if Time.now.seconds_since_midnight - @agent.locktime > 30
			@agent.locked = false
			@agent.save!
		end
	end
	
	if @agent.locked == true	
		update_result = @agent.update_attributes(params[:agent].except(:lat, :long))
	end	
	
	if @agent.emp == true
		Agent.all.each do |victim|
			if victim != @agent
				if Math.sqrt((victim.lat - @agent.lat)**2 + (victim.long - @agent.long)**2) < 0.00004
					if victim.carrier == false
						victim.update_attributes(:locked => true, :locktime => Time.now.seconds_since_midnight)
					end
				end
			else
				update_result = @agent.update_attributes(params[:agent].merge( {:locked => true, :emp => false, :locktime => Time.now.seconds_since_midnight}) )
			end
		end
	end

		
    respond_to do |format|
      if update_result  #if update result
	 
		
        format.html { redirect_to(:json, :notice => 'Agent was successfully updated.') }
        format.xml  { head :ok }
		format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @agent.errors, :status => :unprocessable_entity }
		format.json  { render :json => @agent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /agents/1
  # DELETE /agents/1.xml
  def destroy
    @agent = Agent.find(params[:id])
    @agent.destroy

    respond_to do |format|
      format.html { redirect_to(agents_url) }
      format.xml  { head :ok }
	  format.json  { head :ok }
    end
  end
end
