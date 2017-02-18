# encoding: utf-8

class DateTimeValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if value.is_a?(::DateTime)
    return record[attribute] = value.to_datetime if value.is_a?(::Time) ||
      value.is_a?(::Date)

    record[attribute] = ::DateTime.parse(value || fail)
  rescue
    record.errors.add(attribute, :not_date)
  end
end
