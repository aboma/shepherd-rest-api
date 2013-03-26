module V1::Concerns::Auditable
  extend ActiveSupport::Concern
  
  # add create_buy and updated_by audit fields
  # to parameters based on model state
  def add_audit_params(model, params)
    id = current_user.id
    attrs = { :modified_by => id }
    attrs[:created_by] = id if model.new?
    params.merge(attrs)  
  end
end