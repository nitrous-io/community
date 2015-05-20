class Session < ActiveRecord::SessionStore::Session
  before_save :ensure_user_id_is_set

  protected
  def ensure_user_id_is_set
    self.user_id = self.data['user_id']
  end
end
