class FeedEntry < ActiveRecord::Base
  attr_accessible :content, :guid, :title, :author, :published_at, :url, :bitly_link, :in_scheduler, :in_scheduler_since

  belongs_to :feed

  after_create :create_bitly_link_delayed

  def create_bitly_link_delayed
    Delayed::Job.enqueue BitlyShortenUrl.new(id)
  end

  def create_bitly_link(bitly_client)
    unless self.bitly_link
      update_attributes(bitly_link: bitly_client.shorten(url).short_url)
    end
  end

  def user
    feed.user
  end
end
