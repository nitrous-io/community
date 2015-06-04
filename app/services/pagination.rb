class Pagination
  DEFAULT_PER_PAGE=6
  DEFAULT_PAGE=1

  attr_reader :page, :per_page

  def initialize(collection, options = {})
    page = options[:page]
    per_page = options[:per_page]
    @page = (page.nil? || page == 0) ? DEFAULT_PAGE : page
    @per_page = (per_page.nil? || per_page == 0) ? DEFAULT_PER_PAGE : per_page
    @collection = collection
  end

  def items
    items_with_extra[0...@per_page]
  end

  def more?
    items_with_extra.size > @per_page
  end

  def options_for_next_page
    { page: @page + 1, per_page: @per_page }
  end

  def offset
    (@page - 1) * @per_page
  end

  private
  def items_with_extra
    @_items_with_extra ||= @collection.offset(offset).limit(@per_page + 1)
  end
end