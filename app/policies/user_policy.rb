class UserPolicy < ApplicationPolicy
  def set_location?
    record = user
  end
end