module Searchable
  extend ActiveSupport::Concern

  class_methods do
    # FIXME: This can accept arel but can't return arel for now.
    def search(keyword)
      value            = sanitize(keyword)
      search_view      = self.select(select_for_attributes_and_documents).joins(:taggings, :tags).group(:id).to_sql
      all_column_names = self.column_names.join(',')

      sql = <<-SQL
  SELECT #{all_column_names}
  FROM (#{search_view}) search
  WHERE search.document @@ to_tsquery(#{value})
  ORDER BY ts_rank(search.document, to_tsquery(#{value})) DESC
      SQL

      self.find_by_sql(sql)
    end

    private
    def select_for_attributes_and_documents
      <<-SQL
#{self.table_name}.*,
setweight(to_tsvector(#{self.table_name}.title), 'A') ||
setweight(to_tsvector(#{self.table_name}.content_markdown), 'B') ||
setweight(to_tsvector(coalesce(string_agg(tags.name, ' '))), 'C') as document
      SQL
    end
  end
end