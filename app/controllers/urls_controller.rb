class UrlsController < ApplicationController
  def new
    @url = Url.new
  end

  def create
    @url = Url.new(url_params)
      if @url.save
        flash[:success] = "Your url its shorter now" 
        #Implement the  render the new shortened url
      else
        flash[:error] = "Something went wrong: #{@url.errors}" 
        render 'new'
      end
  end

  def show
  end

  def top
  end

  private

  def url_params
    params.require(:url).permit(:url)
  end
end