class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :paginate, -> (params) {
    offset(params[:offset]).limit(params[:limit])
  }

  def self.get_pagination_metadata(params, query)
    page  = params[:page]&.to_i || 1
    limit = params[:per_page]&.to_i || 10
    offset = (page - 1)*limit
    total_entries = query.count
    total_pages = (total_entries.to_f/limit).ceil
    { page: page, total_pages: total_pages, total_records: total_entries, offset: offset, per_page: limit }
  end

end
