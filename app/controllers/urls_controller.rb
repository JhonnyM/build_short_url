class UrlsController < ApplicationController
  before_action :find_shortened_url, only: [:show, :shorty]

  def new
    @url = Url.new
  end

  def create
    @url = Url.new(url_params)
    @url.sanitize
    if @url.new_url?
      if @url.save
        flash[:success] = "Your url its shorter now" 
        redirect_to shorty_path(@url.short_url)
      else
        flash[:error] = "Something went wrong: #{@url.errors}" 
        render :new
      end
    else
      flash[:success] = 'We found that url in our records'
      redirect_to shorty_path(@url.find_duplicate.short_url)
    end
  end

  def show
    redirect_to @url.sanitize_url
  end

  def top
  end

  def shorty
    host = request.host_with_port
    byebug
    @original_url = @url.sanitize_url
    @short_url = host + '/' + @url.short_url
  end

  private

  def find_shortened_url
    @url = Url.find(UrlEncoderService.instance.bijective_decode(params[:short_url]))
  end

  def url_params
    params.require(:url).permit(:url)
  end
end