# spec/models/url_spec.rb

require 'rails_helper'

RSpec.describe Url, type: :model do
  subject { described_class.new(url: 'http://example.com', access_count: 0) }

  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:access_count) }

  it "cant be blank with nil" do
    subject.url = nil
    subject.valid?
    subject.errors[:url].should include("can't be blank")
  end

  it "cant be blank with nil" do
    subject.url = nil
    subject.valid?
    subject.errors[:url].should include("is invalid")
  end

  it "cant be blank with nil" do
    subject.url = "test"
    subject.valid?
    subject.errors[:url].should include("is invalid")
  end

  describe '#set_access' do
    it 'should increment access_count and save' do
      subject.set_access
      expect(subject.access_count).to eq(1)
    end
  end

  describe '#increase_count' do
    it 'should increment access_count for the given Url instance' do
      subject.save
      subject.increase_count(subject)
      expect(subject.access_count).to eq(1)
    end
  end

  describe '#generate_short_url' do
    it 'should set short_url using UrlEncoderService and save' do
      subject.generate_short_url
      expect(subject.short_url).not_to be_nil
    end
  end

  describe '.decode_url' do
    it 'should decode short_url using UrlEncoderService' do
      subject.save
      decoded_id = UrlEncoderService.bijective_decode(subject.short_url)
      expect(Url.decode_url(subject.short_url)).to eq(decoded_id)
    end
  end

  describe '#new_url?' do
    it 'should return true if the URL is new' do
      expect(subject.new_url?).to be_truthy
    end

    it 'should return false if the URL already exists' do
      existing_url = described_class.create(url: subject.url, access_count: 0)
      expect(subject.new_url?).to be_falsey
    end
  end

  describe '#find_duplicate' do
    it 'should return nil if no duplicate is found' do
      expect(subject.find_duplicate).to be_nil
    end

    it 'should return a duplicate Url instance if found' do
      existing_url = described_class.create(url: subject.url, access_count: 0)
      expect(subject.find_duplicate).to eq(existing_url)
    end
  end

  describe '#sanitize' do
    it 'should sanitize the URL' do
      subject.url = 'https://example.com/'
      subject.sanitize
      expect(subject.sanitize_url).to eq('http://example.com')
    end
  end

  it "https://www.google.com/maps/@37.7651476,-122.4243037,14.5z" do
    subject.url = "https://www.google.com/maps/@37.7651476,-122.4243037,14.5z"
    expect(subject).to be_valid
  end

  it "https://www.google.com/search?newwindow=1&espv=2&biw=1484&bih=777&tbs=qdr%3Am&q=rspec+github&oq=rspec+g&gs_l=serp.1.2.0i20j0l9.10831.11965.0.13856.2.2.0.0.0.0.97.185.2.2.0....0...1c.1.64.serp..0.2.183.kqo6B3dAGtE" do
    subject.url = "https://www.google.com/search?newwindow=1&espv=2&biw=1484&bih=777&tbs=qdr%3Am&q=rspec+github&oq=rspec+g&gs_l=serp.1.2.0i20j0l9.10831.11965.0.13856.2.2.0.0.0.0.97.185.2.2.0....0...1c.1.64.serp..0.2.183.kqo6B3dAGtE"
    expect(subject).to be_valid
  end

  it "my-google.com" do
    subject.url = "my-google.com"
    expect(subject).to be_valid
  end

  it "https://www.sucursalelectronica.com/redir/showLogin.go" do
    subject.url = "https://en.wikipedia.org/wiki/HTML_element#Anchor"
    expect(subject).to be_valid
  end

end
