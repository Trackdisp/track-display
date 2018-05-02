class AdminUserPolicy < ApplicationPolicy
  def index?
    user.is_a?(AdminUser)
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def destroy?
    index?
  end

  def destroy_all?
    destroy?
  end
end
