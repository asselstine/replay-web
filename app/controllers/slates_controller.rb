class SlatesController < ApplicationController

  def now
    render text: (DateTime.now.to_f * 1000).to_i 
  end

  def show
  end

end
