require 'mechanize'

class Api::V1::UrlsController < Api::V1::ApiController
  TOP_URL_DELIMITER = 100.freeze
  ORDER_DELIMITER = 'desc'.freeze

  before_action :set_url, only: [:redirect]

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

  def redirect
    redirect_to @url.sanitize_url, allow_other_host: true
  end

  def top
    render json: Url.top(ORDER_DELIMITER, TOP_URL_DELIMITER), status: :ok
  end

  def bot
    mechanize = Mechanize.new
    page = mechanize.get('http://en.wikipedia.org/wiki/Main_Page/')
    created_objects = []
    # we will get 10 urls
    10.to_i.times do
      link = page.link_with(text: 'Random article')
      page = link.click
      u = Url.new({url: page.uri})
      u.sanitize
      u.save
      created_objects << u
    end
    render json: created_objects
  end

  private

  def find_shortened_url
    @url = Url.find(Url.decode_url(params[:short_url]))
  end

  def set_url
    @url = Url.find(params[:id])
  end

  def url_params
    params.require(:url).permit(:url)
  end

end