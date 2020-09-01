class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin
        scope.all.order(created_at: :desc)
      elsif user.driver
        scope.where(driver: user).order(created_at: :desc) + scope.where(status: 'search').order(created_at: :desc)
      else
        scope.where(client: user).order(created_at: :desc)
      end
    end
  end

  def client?
    user.admin || record.client == user
  end

  def driver?
    user.admin || record.driver == user
  end

  def new?
    user.admin || !user.driver
  end

  def select?
    user.admin || user.driver
  end

  def start?
    driver? && record.status = "accepted"
  end

  def end?
    driver? && record.status = "arrived"
  end

  def map_display?
    user.driver && record.driver == nil
  end

  def create?
    new?
  end

  def update?
    new?
  end

  def set_price?
    new?
  end

  def destroy?
    new?
  end
end
