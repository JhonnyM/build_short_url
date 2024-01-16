class Url < ApplicationRecord
  validates_presence_of :url, :access_count
  validates_format_of :url, with:  /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/
  scope :top, -> (order, limit) { order(access_count: order).limit(limit) }

  def set_access
    self.access_count = self.access_count + 1
    self.save
  end
end
