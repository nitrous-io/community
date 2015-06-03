module Searchable
  extend ActiveSupport::Concern

  class_methods do
    def search(keyword)
      value = sanitize(keyword)
      columns = self.column_names.join(',')
      name = self.name
      table_name = self.table_name
      sql = <<-SQL
  SELECT #{columns}
  FROM (
    SELECT #{table_name}.*,
           setweight(to_tsvector(#{table_name}.title), 'A') ||
           setweight(to_tsvector(#{table_name}.content_markdown), 'B') ||
           setweight(to_tsvector(coalesce(string_agg(tags.name, ' '))), 'C') as document
    FROM #{table_name}
    JOIN taggings ON taggings.taggable_id = #{table_name}.id AND taggings.taggable_type = '#{name}'
    JOIN tags ON taggings.tag_id = tags.id
    GROUP BY #{table_name}.id) search
  WHERE search.document @@ to_tsquery(#{value})
  ORDER BY ts_rank(search.document, to_tsquery(#{value})) DESC
      SQL
      self.find_by_sql(sql)
    end
  end
end