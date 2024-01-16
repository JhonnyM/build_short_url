class UrlsController < ApplicationController
  def new
    @url = Url.new
  end

  def create
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