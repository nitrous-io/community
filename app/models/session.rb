class Session < ActiveRecord::Base
  # Referenced from http://guides.rubyonrails.org/security.html#session-expiry
  # Call Session.sweep(20.minutes) to expire sessions that were used longer than 20 minutes ago.
  # TODO: Track sessions by users.
  def self.sweep(time = 30.days)
    where("updated_at < ? OR created_at < ?", time.ago, 30.days.ago).delete_all
  end
end
