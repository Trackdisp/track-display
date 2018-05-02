class UserPolicy < ApplicationPolicy
  def index?
    user.is_a?(AdminUser)
  end

  def show?
    scope.where(id: record.id).exists? && (index? || user.id == record.id)
  end

  def create?
    index?
  end

  def update?
    show?
  end

  def destroy?
    index?
  end

  def destroy_all?
    destroy?
  end
end
