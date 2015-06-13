module Pageable
  extend ActiveSupport::Concern

  def page
    @_page ||= (params[:page] || 1).to_i
  end

  def per_page
    @_per_page ||= (params[:per_page] || 3).to_i
  end
end
