class Api::V1::UrlsController < Api::V1::ApiController
  def index
    render json: Url.all, status: :ok
  end
  
end