class DiagramController < ApplicationController

  def new
  end

  def create
    @diagram = Diagram.new()
    params['balls'].each do |k, v|
      @diagram.addBall(k, v['x'], v['y'])
    end
    if @diagram.generate()
      response.headers['Content-Type'] = 'image/png'
      response.headers['Content-Disposition'] = 'inline'
      render :text => open(@diagram.getImage(), "rb").read
      @diagram.cleanup()
    else
      render 'new'
    end
  end

end
