class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin
        scope.all
      elsif user.driver
        scope.where(driver: user)
      else
        scope.where(client: user)
      end
    end
  end

  def show?
    user.admin || record.client == user || record.driver == user
  end

  def new?
    user.admin || !user.driver
  end

  def edit?
    user.admin
  end

  def create?
    new?
  end

  def update?
    edit?
  end

  def destroy?
    false
  end
end
