module V1::Concerns::Auditable
  extend ActiveSupport::Concern
  
  # add create_buy and updated_by audit fields
  # to parameters based on model state
  def add_audit_params(model, params)
    raise ArgumentError, 'current_user object not available' unless current_user
    attrs = ActiveSupport::HashWithIndifferentAccess.new
    attrs[:updated_by_id] = current_user.id 
    attrs[:created_by_id] = current_user.id if model.new_record?
    params.merge(attrs)
  end
end