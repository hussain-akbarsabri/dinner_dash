class OrderPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    owner_or_admin?
  end

  def create?
    true
  end

  def new?
    true
  end

  def orders_dashboard?
    admin_authorization
  end

  def update?
    admin_authorization
  end

  def edit?
    admin_authorization
  end

  def destroy?
    admin_authorization
  end

  private

  def owner_or_admin?
    is_owner || @user.admin?
  end

  def is_owner
    @record.user_id == @user.id
  end

  def admin_authorization
    @user.admin?
  end

end
