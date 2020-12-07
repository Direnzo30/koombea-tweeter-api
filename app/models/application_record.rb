class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :paginate, -> (params) {
    offset(params[:offset]).limit(params[:per_page])
  }

end
