module V1::Concerns::Auditable
  extend ActiveSupport::Concern

  # add create_buy and updated_by audit fields
  # to parameters based on model state
  def add_audit_params(model)
    raise ArgumentError, 'current_user object not available' unless current_user
    model.updated_by_id = current_user.id
    model.created_by_id = current_user.id if model.new_record?
  end
end
