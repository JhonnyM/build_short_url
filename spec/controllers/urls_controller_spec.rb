# spec/controllers/urls_controller_spec.rb

require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template :new
    end

    it 'assigns a new Url instance to @url' do
      get :new
      expect(assigns(:url)).to be_a_new(Url)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes for a new URL' do
      let(:valid_attributes) { { url: 'http://example.com' } }

      it 'creates a new URL' do
        expect {
          post :create, params: { url: valid_attributes }
        }.to change(Url, :count).by(1)
      end

      it 'redirects to shorty path' do
        post :create, params: { url: valid_attributes }
        expect(response).to redirect_to(shorty_path(assigns(:url)))
      end
    end

    context 'with valid attributes for an existing URL' do
      let!(:existing_url) { Url.create(url: 'http://example.com') }
      let(:valid_attributes) { { url: existing_url.url } }

      it 'redirects to shorty path of the existing URL' do
        post :create, params: { url: valid_attributes }
        expect(response).to redirect_to(shorty_path(assigns(:url)))
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { url: 'invalid-url' } }

      it 'does not create a new URL' do
        expect {
          post :create, params: { url: invalid_attributes }
        }.not_to change(Url, :count)
      end

      it 'renders the new template' do
        post :create, params: { url: invalid_attributes }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #top' do
    it 'renders the top template' do
      get :top
      expect(response).to render_template :top
    end

    it 'assigns top URLs to @top_urls' do
      top_urls = Array.new(5) { |i| Url.create(url: "http://example#{i}.com") }
      get :top
      expect(assigns(:top_urls)).to match_array(top_urls)
    end
  end

  describe 'GET #shorty' do
    let(:url) { Url.create(url: 'http://example.com') }

    it 'renders the shorty template' do
      get :shorty, params: { id: url.id }
      expect(response).to render_template :shorty
    end

    it 'assigns the original and short URL to @original_url and @short_url' do
      get :shorty, params: { id: url.id }
      expect(assigns(:original_url)).to eq(url.sanitize_url)
      expect(assigns(:short_url)).to eq("#{request.host_with_port}/#{url.short_url}")
    end
  end
end
