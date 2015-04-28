class Session < ActiveRecord::Base
  # Referenced from http://guides.rubyonrails.org/security.html#session-expiry
  # Call Session.sweep("20 minutes") to expire sessions that were used longer than 20 minutes ago.
  # TODO: Track sessions by users.
  def self.sweep(time = 1.hour)
    if time.is_a?(String)
      time = time.split.inject { |count, unit| count.to_i.send(unit) }
    end

    delete_all "updated_at < '#{time.ago.to_s(:db)}' OR created_at < '#{2.days.ago.to_s(:db)}'"
  end
end
