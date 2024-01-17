class Url < ApplicationRecord
  validates_presence_of :url, :access_count
  validates_format_of :url, with:  /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/
  scope :top, -> (order, limit) { order(access_count: order).limit(limit) }

  after_create :generate_short_url

  def set_access
    self.access_count = self.access_count + 1
    self.save
  end

  def increase_count(u)
    u.access_count += 1
    u.save!
  end

  def generate_short_url
    byebug
    # use the bijective function to enconde the url
    self.short_url = UrlEncoderService.bijective_encode(self.id)
    self.save
  end

  def self.decode_url(minified_url)
    UrlEncoderService.bijective_decode(minified_url)
  end

  def new_url?
    u = find_duplicate
    if u.blank?
      true
    else
      increase_count(u)
      false
    end
  end

  def find_duplicate
    u = Url.find_by_sanitize_url(self.sanitize_url)
  end

  def sanitize
    self.url.strip!
    self.sanitize_url = self.url.gsub(/(https?:\/\/)/, "")
    self.sanitize_url.slice!(-1) if self.sanitize_url[-1] == "/"
    self.sanitize_url = "http://#{self.sanitize_url}"
  end
end
