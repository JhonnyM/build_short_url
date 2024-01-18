require 'mechanize'

class UpdatePageTitleJob < ApplicationJob
  queue_as :default

  def perform(url_id)
    begin
      u = Url.find(url_id)
      if u.title.nil?
        u.title = get_page_title u.sanitize_url
        u.save
      end
    ensure
      UpdatePageTitleJob.set(wait_until: Date.tomorrow.noon).perform_later(url_id)
    end
  end

  def get_page_title url
    mechanize = Mechanize.new
    page = mechanize.get(url)
    page.title
  end
end
