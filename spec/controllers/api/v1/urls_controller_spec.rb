require 'rails_helper'
require 'mechanize'

RSpec.describe Api::V1::UrlsController, type: :controller do
  describe 'GET #index' do
    it 'returns a list of URLs' do
      urls = create_urls(5)
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to match_array(urls.as_json)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes for a new URL' do
      let(:valid_attributes) { { url: 'http://example.com' } }

      it 'creates a new URL' do
        expect {
          post :create, params: { url: valid_attributes }
        }.to change(Url, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('url' => valid_attributes[:url])
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { url: 'invalid-url' } }

      it 'does not create a new URL' do
        expect {
          post :create, params: { url: invalid_attributes }
        }.not_to change(Url, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('url' => ['is invalid'])
      end
    end
  end

  describe 'GET #top' do
    it 'returns a list of top URLs' do
      top_urls = create_urls(5)
      get :top
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to match_array(top_urls.as_json)
    end
  end

  describe 'GET #bot' do
    it 'creates 10 new URLs' do
      allow(Mechanize).to receive(:new).and_return(fake_mechanize)
      get :bot
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).count).to eq(10)
    end
  end

  # Helper methods for creating URLs

  def create_urls(count)
    Array.new(count) { create_url }
  end

  def create_url
    url = Url.create(url: 'http://en.wikipedia.org/wiki/Main_Page/')
    url.sanitize_url
    url
  end

  def fake_mechanize
    mechanize = instance_double('Mechanize')
    allow(mechanize).to receive(:get).and_return(fake_page)
    mechanize
  end
  
  def fake_page
    page = double('Page')
    allow(page).to receive(:link_with).and_return(double('Link', click: nil))
    allow(page).to receive(:uri).and_return(URI.parse('http://en.wikipedia.org/wiki/Main_Page/'))
    page
  end
end
