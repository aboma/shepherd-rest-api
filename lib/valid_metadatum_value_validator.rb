class ValidMetadatumValueValidator < ActiveModel::EachValidator
  FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE'].to_set
  TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE'].to_set

  def validate_each(record, attribute, value)
    value = record.metadatum_value
    field = V1::MetadatumField.find_by_id(record.metadatum_field_id)
    type = field.type if field
    return unless type
    if ((type == 'boolean') && !is_boolean_value?(value))
      record.errors.add(attribute, "invalid boolean value '#{value}'")
    end
    if (type == 'integer' && !is_integer?(value))
      record.errors.add(attribute, "invalid integer value '#{value}'")
    end
  end

  def is_boolean_value?(value)
    if value.is_a?(String) && value.blank?
      return false
    else
      return TRUE_VALUES.include?(value) || FALSE_VALUES.include?(value)
    end
  end

  def is_integer?(value)
    true if Integer(value) rescue false
  end

end
