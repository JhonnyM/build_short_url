class Api::V1::UrlsController < Api::V1::ApiController
  def index
    render json: Url.all, status: :ok
  end

  def create
    @url = Url.new(url_params)
    @url.sanitize
    if @url.new_url?
      if @url.save
        render json: @url, status: :created
      else
        render json: @url.errors, status: :unprocessable_entity
      end
    else
      render json: @url.find_duplicate, status: :ok
    end
  end

  def show
    redirect_to @url.sanitize_url
  end

  private

  def find_shortened_url
    @url = Url.find(Url.decode_url(params[:short_url]))
  end

  def url_params
    params.require(:url).permit(:url)
  end

end